terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0, < 6.0" }
  }
}

# Use AWS profile or assume-role (no credentials in code)
provider "aws" {
  region = "us-east-12345"
}

resource "aws_s3_bucket" "demo" {
  bucket = "ow-c3-demo-bucket-svetlin"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire-old-objects"
    enabled = true

    expiration {
      days = 365
    }
  }

  tags = {
    Name        = "ow-c3-demo-bucket-jaswanth"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = true
}