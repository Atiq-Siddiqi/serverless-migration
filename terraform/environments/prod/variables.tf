variable "aws_region" {
  description = "The target AWS region for enterprise resource provisioning"
  type        = string
  default     = "us-east-1"
}

variable "root_id" {
  description = "The AWS Organization root ID or parent identifier"
  type        = string
}

variable "sandbox_admin_email" {
  description = "The administrative email address assigned to the provisioned sandbox account"
  type        = string
}
