# Service Control Policy (SCP) to enforce security baseline and restrict unapproved regions
resource "aws_organizations_policy" "security_guardrails" {
  name        = "EnterpriseSecurityGuardrails"
  description = "Enforces regional restrictions and mandatory encryption standards across accounts."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RestrictUnauthorizedRegions"
        Effect    = "Deny"
        NotAction = [
          "iam:*",
          "route53:*",
          "cloudfront:*",
          "support:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" : [
              "us-east-1",
              "us-east-2"
            ]
          }
        }
      },
      {
        Sid      = "EnforceS3Encryption"
        Effect   = "Deny"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::*/*"
        Condition = {
          Null = {
            "s3:x-amz-server-side-encryption" : "true"
          }
        }
      }
    ]
  })
}

# Attach the Security Guardrail SCP to the Workloads Organizational Unit
resource "aws_organizations_policy_attachment" "attach_workloads_guardrail" {
  policy_id = aws_organizations_policy.security_guardrails.id
  target_id = module.control_tower_ous.workloads_ou_id
}
