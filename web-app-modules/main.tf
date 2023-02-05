terraform {
  backend "s3" {
    bucket         = "altsch00l-terraform-assignment"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "altschool-terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
