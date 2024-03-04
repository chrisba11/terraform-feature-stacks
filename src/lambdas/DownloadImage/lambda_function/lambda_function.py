import boto3
import json
import logging
import os
import requests

bucket_name = os.environ.get('IMAGE_BUCKET_NAME')
bucket_region = os.environ.get('IMAGE_BUCKET_REGION')

s3 = boto3.client('s3', region_name=bucket_region)
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('StatusCodes')

logger = logging.getLogger(__name__)
# logger = logging.getLogger()

log_level_map = {
    'DEBUG': logging.DEBUG,
    'INFO': logging.INFO,
    'WARNING': logging.WARNING,
    'ERROR': logging.ERROR
}


def lambda_handler(event, context):
    try:
        # Set the log level based on the environment variable
        # Default to ERROR if not set
        log_level = log_level_map.get(
            os.environ.get('PYTHON_LOG_LEVEL'), logging.ERROR)

        logger.setLevel(log_level)

        logger.debug('Logger: DEBUG logs will be displayed.')
        logger.info('Logger: INFO logs will be displayed.')
        logger.warn('Logger: WARNING logs will be displayed.')
        logger.error('Logger: ERROR logs will be displayed.')

        logger.info('Event object:' + json.dumps(event))

        try:
            # get StatusCode from event object's body if exists, otherwise use 200
            body = json.loads(event.get('body', '{}'))
            logger.debug(f'body = {body}')
            status_code = body.get('StatusCode', '200')
            logger.debug(f'status_code = {status_code}')
        except Exception as e:
            error_message = str(e)

            logger.error(
                f"An error occurred while parsing the event object's body: {error_message}", exc_info=True)

            return {
                'statusCode': 500,
                'body': json.dumps('Event body parsing failed: ' + error_message)
            }

        # use status code from event to set URL and object name
        image_url = f'https://http.cat/images/{status_code}.jpg'
        object_key = f'DownloadImage/http_cat_{status_code}.jpg'

        try:  # Check DynamoDB Table for provided status code
            response = table.get_item(Key={'status_code': status_code})
            if 'Item' in response:
                try:  # Download the image
                    response = requests.get(image_url)
                    image_data = response.content
                except Exception as e:
                    error_message = str(e)

                    logger.error(
                        f'An error occurred while downloading image: {error_message}', exc_info=True)

                    return {
                        'statusCode': 500,
                        'body': json.dumps('Image download failed: ' + error_message)
                    }

                try:  # Upload the image to S3
                    s3.put_object(
                        Body=image_data,
                        Bucket=bucket_name,
                        Key=object_key
                    )
                except Exception as e:
                    error_message = str(e)

                    logger.error(
                        f'An error occurred while uploading image to S3: {error_message}', exc_info=True)

                    return {
                        'statusCode': 500,
                        'body': json.dumps('S3 upload failed: ' + error_message)
                    }

                # Successfully found status code, downloaded image, and uploaded image
                return {
                    'statusCode': 200,
                    'body': f'Image successfully uploaded to {bucket_name}/{object_key}'
                }
            else:
                return {
                    'statusCode': 400,
                    'body': "Invalid Status Code"
                }
        except Exception as e:
            logger.error(
                f'An error occurred while querying DynamoDB: {error_message}', exc_info=True)

            return {
                'statusCode': 500,
                'body': json.dumps('Error querying DynamoDB: ' + error_message)
            }
    except Exception as e:
        error_message = str(e)

        logger.error(
            f'An error occurred in lambda_handler: {error_message}', exc_info=True)

        return {
            'statusCode': 500,
            'body': json.dumps('Error: ' + error_message)
        }
