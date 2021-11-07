module "object" {
  source = "./object_defined"
  cwagent = {
    enable    = true
    os        = "amazon_linux_2"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}

output "object" {
  value = module.object.attributes
}