module "object" {
  source = "./validation_with_assert"
  cwagent = {
    enable    = true
    os        = "amazon_linux"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}

output "object" {
  value = module.object.attributes
}