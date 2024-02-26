import boto3
import json
import logging
import os
from PIL import Image
import io

bucket_name = os.environ.get('DESTINATION_BUCKET_NAME')
bucket_region = os.environ.get('DESTINATION_BUCKET_REGION')

s3 = boto3.client('s3', region_name=bucket_region)

logger = logging.getLogger(__name__)

log_level_map = {
    'DEBUG': logging.DEBUG,
    'INFO': logging.INFO,
    'WARNING': logging.WARNING,
    'ERROR': logging.ERROR
}


def lambda_handler(event, context):
    try:
        # Set logging level
        log_level = log_level_map.get(
            os.environ.get('PYTHON_LOG_LEVEL'), logging.ERROR)
        logger.setLevel(log_level)

        # Logging examples
        logger.debug('Logger: DEBUG logs will be displayed.')
        logger.info('Logger: INFO logs will be displayed.')
        logger.warning('Logger: WARNING logs will be displayed.')
        logger.error('Logger: ERROR logs will be displayed.')

        # Log the incoming event
        logger.info('Event object:' + json.dumps(event))

        # Assume the status code is used to determine the file name in S3
        body = json.loads(event.get('body', '{}'))
        status_code = body.get('StatusCode', '200')
        object_key = f'DownloadImage/http_cat_{status_code}.jpg'
        new_object_key = f'ReverseImage/reversed_{status_code}.jpg'

        # Download the image from S3
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        image_data = response['Body'].read()

        # Reverse the image using Pillow
        image = Image.open(io.BytesIO(image_data))
        reversed_image = image.transpose(Image.FLIP_LEFT_RIGHT)

        # Save the reversed image to a bytes buffer
        buffer = io.BytesIO()
        reversed_image.save(buffer, format="JPEG")
        buffer.seek(0)

        # Upload the reversed image to S3
        s3.put_object(Body=buffer, Bucket=bucket_name, Key=new_object_key)

        return {
            'statusCode': 200,
            'body': json.dumps(f'Reversed image successfully uploaded to {bucket_name}/{new_object_key}')
        }

    except Exception as e:
        error_message = str(e)
        logger.error(
            f'An error occurred in lambda_handler: {error_message}', exc_info=True)

        return {
            'statusCode': 500,
            'body': json.dumps('Error: ' + error_message)
        }
