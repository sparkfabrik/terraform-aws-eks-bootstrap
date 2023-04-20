locals {
  caches = {
    for key, value in var.application_project : key => {
      cache = value.cache
    }
    if value.cache != null
  }
}

## FIXME
resource "aws_security_group" "this" {
  for_each = local.caches

  name   = "${var.cluster_name}-${each.key}-${each.value.cache.engine}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = each.value.cache.port
    to_port     = each.value.cache.port
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
    Name        = "${var.cluster_name}-${each.key}-${each.value.cache.engine}-sg"
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_elasticache_subnet_group" "this" {
  for_each = local.caches

  name       = "${var.cluster_name}-${each.key}-${each.value.cache.engine}"
  subnet_ids = var.subnet_ids

  tags = {
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_elasticache_cluster" "single" {
  for_each = local.caches

  cluster_id               = "${var.cluster_name}-${each.key}"
  engine                   = each.value.cache.engine
  node_type                = each.value.cache.node_type
  engine_version           = each.value.cache.engine_version
  port                     = each.value.cache.port
  subnet_group_name        = aws_elasticache_subnet_group.this[each.key].name
  security_group_ids       = each.value.cache.security_group_ids != [] ? each.value.cache.security_group_ids : [aws_security_group.this[each.key].id]
  num_cache_nodes          = each.value.cache.num_cache_nodes
  az_mode                  = each.value.cache.az_mode
}
