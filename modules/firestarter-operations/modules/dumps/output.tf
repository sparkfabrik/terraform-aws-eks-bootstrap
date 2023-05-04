output "dumps_admin_role_name" {
  value = local.full_iam_role_name
}

output "dumps_admin_policy_name" {
  value = local.full_iam_policy_name
}

output "dumps_admin_policy_arn" {
  value = aws_iam_policy.dumps_admin.arn
}

output "dumps_reader_policy_name" {
  value = local.full_iam_policy_reader_name
}

output "dumps_reader_policy_arn" {
  value = aws_iam_policy.dumps_reader.arn
}

output "dumps_admin_service_account_name" {
  value = local.full_service_account_name
}
