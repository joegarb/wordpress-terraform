variable "environment" {
  description = "Environment name which will be prefixed on all the resources to be created"
  type        = string
}

variable "site_domain" {
  description = "The primary domain name of the website"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", var.site_domain))
    error_message = "site_domain must be a valid domain name, e.g. \"example.com\" or \"cloud.example.com\"."
  }
}

variable "enable_public_ssh" {
  description = "When true, opens port 22 (SSH) to the internet (0.0.0.0/0). Defaults to false so there is no public SSH ingress."
  type        = bool
  default     = false
}

variable "hosted_zone_name" {
  description = "Name of the existing Route 53 hosted zone that serves DNS for site_domain. Defaults to the apex/registered domain derived from site_domain (e.g. \"cloud.example.com\" => \"example.com\"). Set this to site_domain itself when you delegate the subdomain to its own hosted zone."
  type        = string
  default     = null
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map(any)
  default     = {}
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.small"
}

variable "key_name" {
  description = "SSH key to attach to EC2 instance"
  type        = string
  default     = null
}

variable "letsencrypt_email" {
  description = "Email address required to obtain a SSL cert from Lets Encrypt. If not specified, SSL will be disabled"
  type        = string
  default     = null

  validation {
    condition     = var.letsencrypt_email == null || can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.letsencrypt_email))
    error_message = "letsencrypt_email must be a valid email address."
  }
}

variable "image" {
  description = "Docker image for WordPress"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "Database username for WordPress"
  type        = string
  default     = "wordpress"
}

variable "db_password" {
  description = "Database password for WordPress"
  type        = string
  default     = null
  sensitive   = true
}

variable "wp_debug" {
  description = "Whether to enable WordPress debugging"
  type        = number
  default     = 1
}

variable "wp_debug_log" {
  description = "Whether to write WordPress debug logs. Requires wp_debug to also be set."
  type        = bool
  default     = true
}

variable "wp_extra" {
  description = "Extra config to go into wp-config.php"
  type        = string
  default     = ""
}

variable "scheduled_stop_enabled" {
  description = "Whether to enable scheduled stop and start rules"
  type        = bool
  default     = false
}

variable "scheduled_stop_timezone" {
  description = "Timezone for scheduled stop and start rules"
  type        = string
  default     = "US/Eastern"
}

variable "scheduled_start" {
  description = "Scheduler expression for starting the instance (use along with cron_stop)"
  type        = string
  default     = "cron(0 7 ? * MON-FRI *)"
}

variable "scheduled_stop" {
  description = "Scheduler expression for stopping the instance (such as during the night when it is not in use, or once weekly, etc)"
  type        = string
  default     = "cron(0 3 ? * TUE-SAT *)"
}

variable "sftp_username" {
  description = "SFTP username"
  type        = string
  default     = "ftpuser"
}

variable "sftp_password" {
  description = "SFTP password"
  type        = string
  default     = null
  sensitive   = true
}
