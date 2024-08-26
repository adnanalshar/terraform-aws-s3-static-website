terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "<s3-bucket-name>"
    key            = "static-website/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "<dynamodb-table-name>"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Management = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}
