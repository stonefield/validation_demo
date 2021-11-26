variable "cwagent" {
  description = "CloudWatch agent specification"
  type = map(any)
}

output "attributes" {
  value = var.cwagent
}