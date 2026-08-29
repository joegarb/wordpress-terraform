provider "aws" {
  region = var.region

  default_tags {
    tags = {
      stage     = "staging"
      ManagedBy = "terraform"
    }
  }
}
