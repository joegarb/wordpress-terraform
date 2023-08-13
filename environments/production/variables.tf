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
    stage = "production"
  }
}

variable "db_master_username" {
  description = "Master username of the db"
}

variable "db_master_password" {
  description = "Master password of the db"
}
