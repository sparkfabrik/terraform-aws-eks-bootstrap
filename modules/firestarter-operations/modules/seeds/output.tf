output "seeds_reader_access_key_id" {
  value = aws_iam_access_key.seeds_reader.id
}

output "seeds_reader_secret_key_id" {
  value = aws_iam_access_key.seeds_reader.secret
}

output "seeds_admin_access_key_id" {
  value = aws_iam_access_key.seeds_admin.id
}

output "seeds_admin_secret_key_id" {
  value = aws_iam_access_key.seeds_admin.secret
}
