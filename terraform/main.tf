locals {
  scps = {
    protect-security-services = file("${path.module}/../scps/protect-security-services.json")
    enforce-imdsv2            = file("${path.module}/../scps/enforce-imdsv2.json")
    deny-root-and-iam-users   = file("${path.module}/../scps/deny-root-and-iam-users.json")
    region-allowlist = templatefile("${path.module}/../scps/region-allowlist.json.tftpl", {
      allowed_regions = jsonencode(var.allowed_regions)
    })
  }

  attachments = {
    for pair in setproduct(keys(local.scps), var.target_ou_ids) :
    "${pair[0]}:${pair[1]}" => { policy = pair[0], ou = pair[1] }
  }
}

resource "aws_organizations_policy" "guardrail" {
  for_each    = local.scps
  name        = each.key
  description = "Preventive guardrail: ${each.key}"
  type        = "SERVICE_CONTROL_POLICY"
  content     = each.value
}

resource "aws_organizations_policy_attachment" "guardrail" {
  for_each  = local.attachments
  policy_id = aws_organizations_policy.guardrail[each.value.policy].id
  target_id = each.value.ou
}
