variable "target_ou_ids" {
  description = "Organizational Units (e.g. Workloads, Sandbox) the guardrails are attached to."
  type        = list(string)
}

variable "allowed_regions" {
  description = "Regions workloads may use."
  type        = list(string)
  default     = ["eu-west-1", "eu-west-2"]
}
