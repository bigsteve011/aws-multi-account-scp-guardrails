# AWS Multi-Account Hardening: Control Tower, Service Control Policies (SCPs) & Automated IAM Zero-Trust

> Structuring resilient multi-account AWS Organizations with Control Tower baseline guardrails, atomic Service Control Policies (SCPs) preventing security disablement, IAM Permission Boundaries for developer autonomy, and Security Hub aggregation.

Companion repository for the article **[AWS Multi-Account Hardening: Control Tower, Service Control Policies (SCPs) & Automated IAM Zero-Trust](https://stephen-omowumi.pages.dev/articles/aws-control-tower-scps-iam)** by Stephen Omowumi.

## The problem

Single-account or loosely governed AWS environments create catastrophic blast radiuses. When developers create IAM roles with administrative privileges, compromised keys allow attackers to tamper with CloudTrail, KMS keys, and security baselines.

## Solution architecture

Deploy an AWS Control Tower landing zone with dedicated Security Tooling, Log Archive, and Workload OUs. Attach top-down SCPs that make CloudTrail, GuardDuty, and Security Hub immutable even by root. Require IAM Permission Boundaries on all role creations.

## How it works

1. **Multi-Account Organizational Unit Separation** — Segregate accounts into Core (Security/Log Archive), Production, Staging, and Developer Sandbox OUs.
2. **Immutable Security Service SCPs** — Apply SCP denying Disarm / Delete on CloudTrail, GuardDuty, Config, and KMS Key deletion.
3. **IAM Permission Boundary Enforcement** — Developers can create project IAM roles only if the role has the mandatory Corporate-Boundary attached.
4. **Cross-Account Security Telemetry Aggregation** — Centralize findings in AWS Security Hub Delegated Administrator account with automated event routing.

## Repository layout

```
scps/
  protect-security-services.json   CloudTrail, GuardDuty, Config, Security Hub, Access Analyzer cannot be disabled
  enforce-imdsv2.json              EC2 must launch with IMDSv2 and cannot be downgraded
  deny-root-and-iam-users.json     no root usage, no long-lived IAM users or access keys
  region-allowlist.json.tftpl      workloads restricted to approved regions
terraform/                         creates the SCPs and attaches them to your OUs
```

## Usage

Run from the AWS Organizations management account (or a delegated policy administrator):
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # set target_ou_ids
terraform init && terraform plan
```
Every statement exempts `AWSControlTowerExecution` so Control Tower can still manage accounts. Test on a sandbox OU before attaching to production OUs.

## Outcomes (as described in the article)

| Measure | Result |
|---|---|
| Security Isolation | Multi-OU |
| Log Immutability | Guaranteed |
| SSRF Exposure | 0% (IMDSv2) |

## Key takeaways

- Account-level isolation prevents developer compromises from pivoting into production databases
- SCPs prevent even account root users from disabling audit logs or forensic trails
- Enforced IMDSv2 across all EC2 workloads completely mitigates SSRF credential theft

## Notes

This is a reference implementation. Names, account IDs, regions and allow-lists are placeholders: review and adapt them, and test in a non-production environment before rolling out.

## License

MIT — see [LICENSE](LICENSE).
