output "instance_id" {
  description = "ID of the WordPress EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IPv4 address of the WordPress EC2 instance"
  value       = aws_instance.this.public_ip
}

output "site_url" {
  description = "URL of the WordPress site"
  value       = "${var.letsencrypt_email != null ? "https" : "http"}://${var.site_domain}"
}

output "security_group_id" {
  description = "ID of the instance security group"
  value       = aws_security_group.this.id
}

output "db_password" {
  description = "Database password for WordPress (generated when not supplied via var.db_password)"
  value       = var.db_password != null ? var.db_password : random_password.db_password.result
  sensitive   = true
}

output "sftp_password" {
  description = "SFTP password (generated when not supplied via var.sftp_password)"
  value       = var.sftp_password != null ? var.sftp_password : random_password.sftp_password.result
  sensitive   = true
}
