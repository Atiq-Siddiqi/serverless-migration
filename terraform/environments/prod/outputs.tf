output "security_ou_id" {
  description = "The ID of the Security Organizational Unit"
  value       = module.control_tower_ous.security_ou_id
}

output "workloads_ou_id" {
  description = "The ID of the Workloads Organizational Unit"
  value       = module.control_tower_ous.workloads_ou_id
}

output "sandbox_account_id" {
  description = "The AWS Account ID for the provisioned sandbox environment"
  value       = module.sandbox_account.account_id
}

output "sandbox_account_email" {
  description = "The administrative email associated with the sandbox account"
  value       = module.sandbox_account.account_email
}
