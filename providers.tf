terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"
    }
  }

  backend "s3" {
    bucket = "ngohub-staging-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }

  # cloud {
  #   organization = "code4romania"

  #   workspaces {
  #     tags = [
  #       "ngohub",
  #     ]
  #   }
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Namespace   = "ngohub"
      Environment = var.environment
      Terraform   = true
    }
  }
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"

  default_tags {
    tags = {
      Namespace   = "ngohub"
      Environment = var.environment
      Terraform   = true
    }
  }
}
