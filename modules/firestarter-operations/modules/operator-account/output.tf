output "operator_account_role_name" {
  value = local.full_iam_role_name
}

output "operator_account_seed_policy_name" {
  value = local.full_iam_policy_seed_name
}

output "operator_account_seed_policy_arn" {
  value = aws_iam_policy.operator_account_seed.arn
}

output "operator_account_buckets_policy_name" {
  value = local.full_iam_policy_buckets_name
}

output "operator_account_buckets_policy_arn" {
  value = aws_iam_policy.operator_account_buckets.arn
}

output "operator_account_service_account_name" {
  value = local.full_service_account_name
}
