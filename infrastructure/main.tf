provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "max-tf-state-devs2blu"
  tags = {
    Name = "bucket-devs2blu"
  }
}