# Seeds submodule
output "seeds_bucket_name" {
  value = var.enable_seeds ? local.seeds_bucket_name : "Not enabled"
}

output "seeds_reader_access_key_id" {
  value = length(module.seeds) > 0 ? module.seeds[0].seeds_reader_access_key_id : "Not enabled"
}

output "seeds_reader_secret_key_id" {
  value = length(module.seeds) > 0 ? module.seeds[0].seeds_reader_secret_key_id : "Not enabled"
}

output "seeds_admin_access_key_id" {
  value = length(module.seeds) > 0 ? module.seeds[0].seeds_admin_access_key_id : "Not enabled"
}

output "seeds_admin_secret_key_id" {
  value = length(module.seeds) > 0 ? module.seeds[0].seeds_admin_secret_key_id : "Not enabled"
}

# Operator account submodule
output "operator_account_role_name" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_role_name : "Not enabled"
}

output "operator_account_seed_policy_name" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_seed_policy_name : "Not enabled"
}

output "operator_account_seed_policy_arn" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_seed_policy_arn : "Not enabled"
}

output "operator_account_buckets_policy_name" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_buckets_policy_name : "Not enabled"
}

output "operator_account_buckets_policy_arn" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_buckets_policy_arn : "Not enabled"
}

output "operator_account_service_account_name" {
  value = length(module.operator_account) > 0 ? module.operator_account[0].operator_account_service_account_name : "Not enabled"
}

# Uninstalled releases submodule
output "uninstalled_releases_role_name" {
  value = length(module.uninstalled_releases) > 0 ? module.uninstalled_releases[0].uninstalled_releases_role_name : "Not enabled"
}

output "uninstalled_releases_policy_name" {
  value = length(module.uninstalled_releases) > 0 ? module.uninstalled_releases[0].uninstalled_releases_policy_name : "Not enabled"
}

output "uninstalled_releases_policy_arn" {
  value = length(module.uninstalled_releases) > 0 ? module.uninstalled_releases[0].uninstalled_releases_policy_arn : "Not enabled"
}

output "uninstalled_releases_service_account_name" {
  value = length(module.uninstalled_releases) > 0 ? module.uninstalled_releases[0].uninstalled_releases_service_account_name : "Not enabled"
}

# Dumps submodule
output "dumps_admin_role_name" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_admin_role_name : "Not enabled"
}

output "dumps_admin_policy_name" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_admin_policy_name : "Not enabled"
}

output "dumps_admin_policy_arn" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_admin_policy_arn : "Not enabled"
}

output "dumps_reader_policy_name" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_reader_policy_name : "Not enabled"
}

output "dumps_reader_policy_arn" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_reader_policy_arn : "Not enabled"
}

output "dumps_admin_service_account_name" {
  value = length(module.dumps) > 0 ? module.dumps[0].dumps_admin_service_account_name : "Not enabled"
}
