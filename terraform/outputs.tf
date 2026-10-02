output "policy_ids" {
  value = { for k, p in aws_organizations_policy.guardrail : k => p.id }
}
