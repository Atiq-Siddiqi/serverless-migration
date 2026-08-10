variable "root_id" {
  type = string
}

variable "security_ou_name" {
  type    = string
  default = "Security"
}

variable "workloads_ou_name" {
  type    = string
  default = "Workloads"
}

resource "aws_organizations_organizational_unit" "security" {
  name      = var.security_ou_name
  parent_id = var.root_id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = var.workloads_ou_name
  parent_id = var.root_id
}
