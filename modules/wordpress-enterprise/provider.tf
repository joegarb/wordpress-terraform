terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
}
