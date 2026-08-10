output "security_ou_id" {
  value = aws_organizations_organizational_unit.security.id
}

output "workloads_ou_id" {
  value = aws_organizations_organizational_unit.workloads.id
}
