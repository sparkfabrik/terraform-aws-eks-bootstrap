output "uninstalled_releases_role_name" {
  value = local.full_iam_role_name
}

output "uninstalled_releases_policy_name" {
  value = local.full_iam_policy_name
}

output "uninstalled_releases_policy_arn" {
  value = aws_iam_policy.uninstalled_releases.arn
}

output "uninstalled_releases_service_account_name" {
  value = local.full_service_account_name
}
