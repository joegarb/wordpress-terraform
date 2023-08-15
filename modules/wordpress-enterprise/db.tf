resource "random_string" "snapshot_suffix" {
  length  = 8
  special = false
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.environment}"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  vpc_security_group_ids  = [aws_security_group.db.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  engine_version          = var.db_engine_version
  availability_zones      = slice(data.aws_availability_zones.this.names, 0, 3)
  database_name           = "wordpress"
  master_username         = var.db_username
  master_password         = var.db_password != null ? var.db_password : random_password.db_password.result
  backup_retention_period = var.db_backup_retention_days
  preferred_backup_window = var.db_backup_window
  serverlessv2_scaling_configuration {
    min_capacity = var.db_min_capacity
    max_capacity = var.db_max_capacity
  }
  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
  final_snapshot_identifier = "${var.environment}-${random_string.snapshot_suffix.result}"
  tags                      = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  cluster_identifier = aws_rds_cluster.this.id
  instance_class = "db.serverless"
  engine = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}"
  subnet_ids = module.vpc.private_subnets
  tags       = var.tags
}

resource "aws_security_group" "db" {
  vpc_id = module.vpc.vpc_id
  name   = "${var.environment}-db"
  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "random_password" "db_password" {
  length = 20
  special = true
  override_special = "!#%&*-_=+?"
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.environment}/db_user"
  type  = "SecureString"
  value = var.db_username
  tags  = var.tags
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.environment}/db_password"
  type  = "SecureString"
  value = var.db_password != null ? var.db_password : random_password.db_password.result
  tags  = var.tags
}
