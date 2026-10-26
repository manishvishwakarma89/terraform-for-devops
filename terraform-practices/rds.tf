# RDS MySQL in the private subnets from vpc.tf.
# Assumes aws_vpc.main, aws_subnet.private and aws_security_group.my_sg
# (the EC2 security group, which must also be in aws_vpc.main).

locals {
  rds_identifier = "main-mysql"
  rds_db_name    = "appdb"
  rds_username   = "admin"
}
resource "aws_db_subnet_group" "main" {
  name       = "${local.rds_identifier}-subnets"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${local.rds_identifier}-subnets"
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.rds_identifier}-sg"
  description = "Allow MySQL from the app security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from app instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.my_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.rds_identifier}-sg"
  }
}
resource "aws_db_instance" "mysql" {
  identifier = local.rds_identifier

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = local.rds_db_name
  username = local.rds_username

  # RDS generates the password and stores it in Secrets Manager,
  # so it never appears in your .tf files.
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false # set true for production

  backup_retention_period = 1
  deletion_protection     = false
  skip_final_snapshot     = true # practice only; use a final snapshot in production

  tags = {
    Name = local.rds_identifier
  }
}


