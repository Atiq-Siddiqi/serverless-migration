output "account_id" {
  value = aws_organizations_account.sandbox.id
}

output "account_email" {
  value = aws_organizations_account.sandbox.email
}
