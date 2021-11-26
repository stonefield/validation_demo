module "demo" {
  source = "./work"
  cwagent = {
    enable = true
    os     = "amazon_linux"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}

output "demo" {
  value = module.demo.attributes
}