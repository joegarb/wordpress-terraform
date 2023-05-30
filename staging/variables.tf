variable "prefix" {
  description = "Prefix for all the resources to be created"
  default     = "demo-tf-staging"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map
  default     = {}
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key to attach to EC2 instance"
  default     = null
}
