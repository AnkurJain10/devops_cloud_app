resource "aws_s3_bucket" "narvar-tfbackend" {
  bucket = "narvar-tfbackend"
  acl = "private"
  versioning {
    enabled = true
  }
  
  tags {
    Name = "Narvar App Terraform Backend"
    Owner = "Ankur"
  }
}

provider "aws" { 
    region = "us-east-1"
}
