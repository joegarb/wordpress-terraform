resource "aws_instance" "this" {
  tags = (merge(
    {
      "Name"          = var.environment,
      "AUTO_DNS_NAME" = var.site_domain,
      "AUTO_DNS_ZONE" = aws_route53_record.this.zone_id
    },
    var.tags
  ))
  ami                    = data.aws_ami.this.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  user_data_base64       = data.cloudinit_config.this.rendered

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

data "cloudinit_config" "this" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/user-data.sh")
  }

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = base64encode(file("${path.module}/update-ip.sh"))
          path        = "/var/lib/cloud/scripts/per-boot/update-ip.sh"
          defer       = true
          owner       = "ec2-user:ec2-user"
          permissions = "0755"
        },
        {
          content     = <<-EOF
            client_max_body_size 0;
          EOF
          path        = "/home/ec2-user/nginx-proxy.conf"
          defer       = true
          owner       = "ec2-user:ec2-user"
          permissions = "0644"
        },
        {
          encoding = "b64"
          content = base64encode(templatefile("${path.module}/docker-compose.yml", {
            image             = var.image
            site_domain       = var.site_domain
            url_scheme        = var.letsencrypt_email != null ? "https" : "http"
            letsencrypt_host  = var.letsencrypt_email != null ? var.site_domain : ""
            letsencrypt_email = var.letsencrypt_email != null ? var.letsencrypt_email : ""
            db_username       = var.db_username
            db_password       = var.db_password != null ? var.db_password : random_password.db_password.result
            wp_debug          = var.wp_debug
            wp_debug_log      = var.wp_debug_log
            wp_extra          = var.wp_extra
            sftp_username     = var.sftp_username
            sftp_password     = var.sftp_password != null ? var.sftp_password : random_password.sftp_password.result
          }))
          path        = "/home/ec2-user/docker-compose.yml"
          defer       = true
          owner       = "ec2-user:ec2-user"
          permissions = "0644"
        }
      ]
    })
  }
}

# Latest Amazon Linux 2023 image
data "aws_ami" "this" {
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  owners      = ["amazon"]
  most_recent = true
}

# AWS-managed prefix list for the EC2 Instance Connect service, so port 22 can be
# reached via EC2 Instance Connect without opening SSH to the whole internet.
data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${data.aws_region.current.region}.ec2-instance-connect"
}

locals {
  # Ports open to the public internet (IPv4 and IPv6).
  public_ingress = {
    https = { port = 443, description = "Port 443 HTTPS" }
    http  = { port = 80, description = "Port 80 HTTP" }
    sftp  = { port = 2222, description = "Port 2222 SFTP" }
  }
}

resource "aws_security_group" "this" {
  name        = var.environment
  tags        = var.tags
  description = "Allow HTTP/HTTPS/SSH/SFTP inbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "public_ipv4" {
  for_each          = local.public_ingress
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "public_ipv6" {
  for_each          = local.public_ingress
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv6         = "::/0"
}

# SSH via the EC2 Instance Connect service only (no public exposure).
resource "aws_vpc_security_group_ingress_rule" "ssh_instance_connect" {
  security_group_id = aws_security_group.this.id
  description       = "Port 22 SSH via EC2 Instance Connect"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  prefix_list_id    = data.aws_ec2_managed_prefix_list.ec2_instance_connect.id
}

# Optional public SSH from anywhere, gated by var.enable_public_ssh.
resource "aws_vpc_security_group_ingress_rule" "ssh_public_ipv4" {
  count             = var.enable_public_ssh ? 1 : 0
  security_group_id = aws_security_group.this.id
  description       = "Port 22 SSH (public)"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_public_ipv6" {
  count             = var.enable_public_ssh ? 1 : 0
  security_group_id = aws_security_group.this.id
  description       = "Port 22 SSH (public)"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv6         = "::/0"
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.this.id
  description       = "Outgoing - ALL"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all_ipv6" {
  security_group_id = aws_security_group.this.id
  description       = "Outgoing - ALL"
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}

resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#%&*-_=+?"
}

resource "random_password" "sftp_password" {
  length           = 20
  special          = true
  override_special = "!#%&*-_=+?"
}

resource "aws_iam_policy" "ec2_update_ip" {
  name        = "${var.environment}-ec2-update-ip"
  description = "Allows EC2 instances to update their own IP in Route 53"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeTags"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::hostedzone/${aws_route53_record.this.zone_id}"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_ecr_policy" {
  name        = "${var.environment}-ec2-ecr"
  description = "Provides access to ECR from EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:ListImages"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name = var.environment

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_update_ip" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ec2_update_ip.arn
}

resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ec2_ecr_policy.arn
}

resource "aws_iam_instance_profile" "this" {
  name = var.environment
  role = aws_iam_role.this.name
}
