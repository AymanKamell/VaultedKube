resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

# Generate DB password (no hardcoding)
resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "_-@#"
}

# Secrets Manager secret container
resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project_name}/rds/postgres"
  description             = "Postgres credentials for ${var.project_name}"
  recovery_window_in_days = var.secret_recovery_window_days

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-secret"
  })
}

# RDS Instance
resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  port = 5432

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  multi_az            = var.multi_az
  publicly_accessible = false

  storage_encrypted = true
  kms_key_id        = var.kms_key_id

  backup_retention_period = var.backup_retention_days
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  # Nice-to-have defaults
  auto_minor_version_upgrade = true
  apply_immediately          = var.apply_immediately

  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  tags = merge(var.tags, {
    Name = "${var.project_name}-postgres"
  })

  depends_on = [aws_db_subnet_group.this]
}

# Store connection JSON in Secrets Manager (after RDS is created so host is known)
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    engine   = "postgres"
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = var.db_name
    endpoint = aws_db_instance.this.endpoint
  })

  depends_on = [aws_db_instance.this]
}

