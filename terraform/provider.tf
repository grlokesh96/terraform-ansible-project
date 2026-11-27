terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Enterprise S3 Backend (uncomment after bucket creation)
  # backend "s3" {
  #   bucket         = "terraform-ansible-state-grlokesh96"
  #   key            = "envs/${var.environment}/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  # FIX: Use provider-level default_tags instead of repeating tags on every
  # resource block. These merge with any resource-level tags automatically.
  default_tags {
    tags = {
      Project     = "terraform-ansible"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
