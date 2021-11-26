
variable "cwagent" {
  description = "CloudWatch agent specification"
  type        = object({})
}

output "attributes" {
  value = var.cwagent
}