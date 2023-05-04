locals {
  seeds_bucket_name                = join("-", [var.project, var.environment, "seeds"])
  uninstalled_releases_bucket_name = join("-", [var.project, var.environment, "uninstalled-releases"])
  dumps_bucket_name                = join("-", [var.project, var.environment, "dumps"])
}

module "seeds" {
  count = var.enable_seeds ? 1 : 0

  source = "./modules/seeds"

  namespaces  = var.namespaces
  project     = var.project
  environment = var.environment
  bucket_name = local.seeds_bucket_name
  aws_tags    = var.aws_tags
}

module "operator_account" {
  count = var.enable_operator_account ? 1 : 0

  source = "./modules/operator-account"

  namespaces                  = var.namespaces
  oidc_provider_url           = var.oidc_provider_url
  project                     = var.project
  environment                 = var.environment
  iam_role_name_prefix        = var.operator_account_role_name_prefix
  iam_policy_name_prefix      = var.operator_account_policy_name_prefix
  service_account_name_prefix = var.operator_account_service_account_name_prefix
  seeds_bucket_name           = local.seeds_bucket_name
  aws_tags                    = var.aws_tags
}

module "uninstalled_releases" {
  count = var.enable_uninstalled_releases ? 1 : 0

  source = "./modules/uninstalled-releases"

  namespaces                  = var.namespaces
  oidc_provider_url           = var.oidc_provider_url
  project                     = var.project
  environment                 = var.environment
  enable_bucket_lifecycle     = var.uninstalled_releases_enable_bucket_lifecycle
  infrequently_access_days    = var.uninstalled_releases_infrequently_access_days
  glacier_days                = var.uninstalled_releases_glacier_days
  expiration_days             = var.uninstalled_releases_expiration_days
  iam_role_name_prefix        = var.uninstalled_releases_role_name_prefix
  iam_policy_name_prefix      = var.uninstalled_releases_policy_name_prefix
  service_account_name_prefix = var.uninstalled_releases_service_account_name_prefix
  bucket_name                 = local.uninstalled_releases_bucket_name
  aws_tags                    = var.aws_tags
}

module "dumps" {
  count = var.enable_dumps ? 1 : 0

  source = "./modules/dumps"

  namespaces                  = var.namespaces
  oidc_provider_url           = var.oidc_provider_url
  project                     = var.project
  environment                 = var.environment
  enable_bucket_lifecycle     = var.dumps_enable_bucket_lifecycle
  infrequently_access_days    = var.dumps_infrequently_access_days
  glacier_days                = var.dumps_glacier_days
  expiration_days             = var.dumps_expiration_days
  iam_role_name_prefix        = var.dumps_admin_role_name_prefix
  iam_policy_name_prefix      = var.dumps_admin_policy_name_prefix
  service_account_name_prefix = var.dumps_admin_service_account_name_prefix
  bucket_name                 = local.dumps_bucket_name
  aws_tags                    = var.aws_tags
}
