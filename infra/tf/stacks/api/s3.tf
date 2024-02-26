resource "aws_s3_bucket" "images" {
  bucket = local.image_bucket_name
}
