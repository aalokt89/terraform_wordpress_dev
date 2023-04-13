terraform {
  cloud {
    organization = "aalok-trivedi"
    workspaces {
      name = "wordpress_app_dev_us_east_1"
    }
  }
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
      App         = local.app_name
      Environment = local.environment
      Terraform   = "True"
    }
  }
}
