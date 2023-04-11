terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      App         = var.app_name
      Environment = var.environment
      Terraform   = "True"
    }
  }
}
