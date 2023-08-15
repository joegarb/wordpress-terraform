variable "environment" {
  description = "Environment name which will be prefixed on all the resources to be created"
  default     = "production"
}

variable "site_domain" {
  description = "The primary domain name of the website"
}

variable "public_alb_domain" {
  description = "The public domian name of the ALB"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map
  default     = {
    stage     = "production"
  }
}
