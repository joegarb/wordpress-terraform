variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name which will be prefixed on all the resources to be created"
  type        = string
  default     = "staging-1"
}

variable "site_domain" {
  description = "The primary domain name of the website"
  type        = string
}

variable "hosted_zone_name" {
  description = "Name of the existing Route 53 hosted zone that serves DNS for site_domain. Leave unset to use the apex/registered domain derived from site_domain (e.g. \"cloud.example.com\" => \"example.com\"). Set this to site_domain itself when you delegate the subdomain to its own hosted zone."
  type        = string
  default     = null
}

variable "enable_public_ssh" {
  description = "When true, opens port 22 (SSH) to the internet (0.0.0.0/0). Defaults to false so there is no public SSH ingress."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra AWS tags to add to resources created by the module. Common tags (stage, ManagedBy) are applied to every resource via the provider's default_tags."
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
