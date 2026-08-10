# Core Organizational Structure
module "control_tower_ous" {
  source = "../modules/control_tower_ous"

  root_id           = var.root_id
  security_ou_name  = "Security"
  workloads_ou_name = "Workloads"
}

# Automated Sandbox Account Provisioning
module "sandbox_account" {
  source = "../modules/sandbox_account"

  parent_ou_id  = module.control_tower_ous.workloads_ou_id
  account_name  = "sandbox-workload-01"
  account_email = var.sandbox_admin_email
}
