variable "parent_ou_id" {
  type = string
}

variable "account_name" {
  type    = string
  default = "sandbox-account"
}

variable "account_email" {
  type = string
}

resource "aws_organizations_account" "sandbox" {
  name      = var.account_name
  email     = var.account_email
  parent_id = var.parent_ou_id
}
