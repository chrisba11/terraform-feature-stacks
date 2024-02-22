terraform {
  backend "s3" {
    region  = "us-west-2"
    encrypt = true
  }
}
