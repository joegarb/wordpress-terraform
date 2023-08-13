variable "environment" {
  description = "Environment name which will be prefixed on all the resources to be created"
  default     = "staging-1"
}

variable "site_domain" {
  description = "The primary domain name of the website"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map
  default     = {
    stage = "staging"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small"
}

variable "key_name" {
  description = "SSH key to attach to EC2 instance"
  default     = null
}

variable "letsencrypt_email" {
  description = "Email address required to obtain a SSL cert from Lets Encrypt. If not specified, SSL will be disabled"
  default     = null
}

variable "image" {
  description = "Docker image for WordPress"
  default     = "wordpress"
}

variable "db_username" {
  description = "Database username for WordPress"
  default     = "wordpress"
}

variable "db_password" {
  description = "Database password for WordPress"
  default     = null
}

variable "wp_debug" {
  description = "Whether to enable WordPress debugging"
  default     = 1
}

variable "wp_debug_log" {
  description = "Whether to write WordPress debug logs. Requires wp_debug to also be set."
  default     = true
}

variable "wp_extra" {
  description = "Extra config to go into wp-config.php"
  default     = ""
}

variable "sftp_username" {
  description = "SFTP username"
  default     = "ftpuser"
}

variable "sftp_password" {
  description = "SFTP password"
  default     = null
}
