

#########################################################
# TERRAFORM BLOCK
#########################################################

terraform {
  required_version = ">=1.1.0"

  backend "s3" {
    bucket         = "backend-0201-lekan-kesh-buck"
    key            = "path/env"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#########################################################
# PROVIDER BLOCK
#########################################################

provider "aws" {
  region  = "us-east-1"
  profile = "iamadmin"

}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

#########################################################
# DATA SOURCE BLOCK
#########################################################
data "aws_availability_zones" "available" {
  state = "available"

}

#########################################################
# MODULE BLOCK
#########################################################

module "vpc" {
  source = "../.."

  component            = "testin_module"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = local.azs
  public_subnet_cidr   = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  backend_subnet_cidr  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  database_subnet_cidr = ["10.0.51.0/24", "10.0.53.0/24", "10.0.55.0/24"]

}

