output "instance_id" {
  description = "ID of the WordPress EC2 instance"
  value       = module.environment.instance_id
}

output "public_ip" {
  description = "Public IPv4 address of the WordPress EC2 instance"
  value       = module.environment.public_ip
}

output "site_url" {
  description = "URL of the WordPress site"
  value       = module.environment.site_url
}

output "security_group_id" {
  description = "ID of the instance security group"
  value       = module.environment.security_group_id
}

output "db_password" {
  description = "Database password for WordPress (generated when not supplied)"
  value       = module.environment.db_password
  sensitive   = true
}

output "sftp_password" {
  description = "SFTP password (generated when not supplied)"
  value       = module.environment.sftp_password
  sensitive   = true
}
