terraform {
  backend "s3" {
    bucket = "narvar-tfbackend"
    key    = "web-app2/application.tfstate"
    region = "us-east-1"
    profile = "aws-orion"
  }
}
