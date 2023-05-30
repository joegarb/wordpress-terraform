provider "aws" {
}

terraform {
  backend "s3" {
  }
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
}

provider "random" {
}
