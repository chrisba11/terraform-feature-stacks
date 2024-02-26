resource "aws_s3_bucket" "image" {
  bucket = local.image_bucket_name
}
