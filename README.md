## 1. Using map

### 1.1 Map does not accept differnt types
```hcl
module "object" {
  source = "./map"
  cwagent = {
    enable    = true
    os        = "amazon_linux_2"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}
```

Result:
```
│ Error: Invalid value for module argument
│ 
│   on test.tf line 3, in module "object":
│    3:   cwagent = {
│    4:     enable    = true
│    5:     os        = "amazon_linux_2"
│    6:     log_group = {
│    7:       cluster = "my-cluster"
│    8:       role    = "my-role"
│    9:     }
│   10:     #metrics_namespace = "my-asg"
│   11:     namespace = "my-asg"
│   12:   }
│ 
│ The given value is not suitable for child module variable "cwagent" defined at map/variables.tf:1,1-19: all map elements must have the same type.
```

### 1.2 map when log\_group is commented

```hcl
module "object" {
  source = "./map"
  cwagent = {
    enable    = true
    os        = "amazon_linux_2"
    # log_group = {
    #   cluster = "my-cluster"
    #   role    = "my-role"
    # }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}
```

Result:
```
Changes to Outputs:
  + object = {
      + "enable"    = "true"
      + "namespace" = "my-asg"
      + "os"        = "amazon_linux_2"
    }
```
Terraform changes boolean to string. This happens with numbers as well.

## 2. Using object

### 2.1 object without attributes definition

```hcl
module "object" {
  source = "./object"
  cwagent = {
    enable    = true
    os        = "amazon_linux_2"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}
```

Result:
```
Changes to Outputs:
  + object = {}
```
Any parameter is now gone, since object has no defined attributes

### 2.2 object with attributes defined

```hcl
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
```

Result:
```
Changes to Outputs:
  + object = {
      + enable            = true
      + log_group         = {
          + cluster = "my-cluster"
          + role    = "my-role"
        }
      + metrics_namespace = "my-asg"
      + os                = "amazon_linux_2"
    }
```

```hcl
module "object" {
  source = "./object_defined"
  cwagent = {
    enable    = true
    os        = "amazon_linux_2"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}
```

Result:
```
Error: Invalid value for module argument
│ 
│   on test.tf line 3, in module "object":
│    3:   cwagent = {
│    4:     enable    = true
│    5:     os        = "amazon_linux_2"
│    6:     log_group = {
│    7:       cluster = "my-cluster"
│    8:       role    = "my-role"
│    9:     }
│   10:     #metrics_namespace = "my-asg"
│   11:     namespace = "my-asg"
│   12:   }
│ 
│ The given value is not suitable for child module variable "cwagent" defined at object_defined/variables.tf:1,1-19: attribute "metrics_namespace" is required.
```



```hcl
```

Result:
```
```

```hcl
```

Result:
```
```

```hcl
```

Result:
```
```

```hcl
```

Result:
```
```

```hcl
```

Result:
```
```

```hcl
```

Result:
```
```

