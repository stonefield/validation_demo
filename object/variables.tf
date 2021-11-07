/*terraform {
  experiments = [module_variable_optional_attrs]
}
*/
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({})
}

output "attributes" {
  value = var.cwagent
}