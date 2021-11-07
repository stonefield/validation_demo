variable "cwagent" {
  description = "CloudWatch agent specification"
}

output "attributes" {
  value = var.cwagent
}

