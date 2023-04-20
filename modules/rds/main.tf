# locals {
#   db_instance_from_snapshot = length(var.snapshot_id) > 0
#   generate_random_password  = (var.database_password == "")
# }

locals {
  # databases = {
  #   for key, value in var.application_project : key => {
  #     database = value.database
  #   }
  # }
  # my_new_map = {for key, value in var.my_map: key => "prefix/${value}"}
  databases = {
    for key, value in var.application_project : key => {
      database = value.database
    }
    if value.database != null
  }
  empty_databases = {
    for key, value in var.application_project : key => {
      database = value.database
    }
    if value.database.snapshot_id == null
  }
  random_password = {
    for key, value in var.application_project : key => {
      database = value.database
    }
    if value.database.password == null
  }
  # from_snapshot_databases = {
  #   for key, value in var.application_project : key => {
  #     database = value.database
  #   }
  #   if value.database.snapshot_id != null
  # }  
}

## FIXME
resource "aws_security_group" "this" {
  name   = "${var.cluster_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.cluster_name}-rds-sg"
    Cluster = var.cluster_name
  }
}

resource "random_password" "master" {
  for_each = local.random_password

  length           = 32
  special          = true
  override_special = "_!%^"
}

resource "aws_db_subnet_group" "this" {
  for_each = local.databases

  name       = "${var.cluster_name}-${each.key}"
  subnet_ids = var.subnet_ids

  tags = {
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_db_parameter_group" "this" {
  for_each = local.databases

  name        = "${var.cluster_name}-${each.key}-parameter-group"
  family      = "${each.value.database.engine}${each.value.database.engine_version}"
  description = "${var.cluster_name}-${each.key} RDS parameter group"

  tags = {
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_db_instance" "db_empty" {
  for_each = local.empty_databases

  identifier     = "${var.cluster_name}-${each.key}"
  engine         = each.value.database.engine
  engine_version = each.value.database.engine_version
  instance_class = each.value.database.instance_class

  storage_type          = each.value.database.storage_type
  allocated_storage     = each.value.database.allocated_storage
  max_allocated_storage = each.value.database.max_allocated_storage
  storage_encrypted     = each.value.database.storage_encrypted

  multi_az = each.value.database.multi_az
  skip_final_snapshot = each.value.database.skip_final_snapshot
  copy_tags_to_snapshot = each.value.database.copy_tags_to_snapshot

  auto_minor_version_upgrade = each.value.database.auto_minor_version_upgrade

  db_name  = each.key
  username = each.value.database.username
  password = each.value.database.password != null ? each.value.database.password : random_password.master[each.key].result
  port     = each.value.database.port

  db_subnet_group_name            = aws_db_subnet_group.this[each.key].name
  enabled_cloudwatch_logs_exports = each.value.database.logs_exports
  vpc_security_group_ids          = [aws_security_group.this.id]
  # Maintenance and backup.
  maintenance_window      = each.value.database.maintenance_window
  apply_immediately       = each.value.database.apply_immediately
  backup_window           = each.value.database.backup_window
  backup_retention_period = each.value.database.backup_retention_period

  depends_on = [aws_db_subnet_group.this, aws_db_parameter_group.this]
}
