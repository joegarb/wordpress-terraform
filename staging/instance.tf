resource "aws_instance" "this" {
  tags                   = "${merge({"Name" = "${var.prefix}-wordpress"}, var.tags)}"
  ami                    = data.aws_ami.this.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = data.cloudinit_config.this.rendered
}

data "cloudinit_config" "this" {
  part {
    content_type = "text/x-shellscript"
    content      = file("user-data.sh")
  }

  part {
    content_type = "text/cloud-config"
    content      = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = base64encode(templatefile("docker-compose.yml", {
            image             = var.image
            site_domain       = var.site_domain
            url_scheme        = var.letsencrypt_email != null ? "https" : "http"
            letsencrypt_host  = var.letsencrypt_email != null ? var.site_domain : ""
            letsencrypt_email = var.letsencrypt_email != null ? var.letsencrypt_email : ""
            db_username       = var.db_username
            db_password       = var.db_password
            wp_debug          = var.wp_debug
            wp_debug_log      = var.wp_debug_log
            wp_extra          = var.wp_extra
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

locals {
  ingress = [{
      port        = 443
      description = "Port 443 HTTPS"
      protocol    = "tcp"
  },
  {
      port        = 80
      description = "Port 80 HTTP"
      protocol    = "tcp"
  },
  {
      port        = 22
      description = "Port 22 SSH"
      protocol    = "tcp"
  }
  ]
}

resource "aws_security_group" "this" {
  name        = "${var.prefix}-wordpress"
  tags        = var.tags
  description = "Allow HTTP/HTTPS/SSH inbound traffic"

  dynamic "ingress" {
      for_each = local.ingress
      content {
        description      = ingress.value.description
        from_port        = ingress.value.port
        to_port          = ingress.value.port
        protocol         = ingress.value.protocol
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
      }
  }
  
  egress = [
    {
      description      = "Outgoing - ALL"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false 
    }
  ]
}
