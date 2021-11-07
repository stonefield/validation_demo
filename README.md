## 1. Using map

Sub mudule `map`:
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = map(any)
}
```


### 1.1 Map does not accept different types

Main module:
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

Main module:
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

Sub module `object`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({})
}
```

Main module:
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

Sub module `object_defined`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({
    enable = bool
    os = string
    log_group = object({
      cluster = string
      role    = string
      })
    metrics_namespace = string
  })
}
```

Main module:
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

### 2.3 object with attributes defined, but one attribute is missing

Main module:
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

### 2.3 object with optional attributes defined

Sub module `optional_attributes`
```hcl
terraform {
  experiments = [module_variable_optional_attrs]
}

variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({
    enable = bool
    log_group = object({
      cluster = string
      role    = string
      })
    metrics_namespace = optional(string)
  })
}

output "attributes" {
  value = var.cwagent
}
```

Main module:
```hcl
module "object" {
  source = "./optional_attributes"
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
  + object = {
      + enable            = true
      + log_group         = {
          + cluster = "my-cluster"
          + role    = "my-role"
        }
      + metrics_namespace = null
    }
```

**Some variants of the output**

```hcl
output "attributes" {
  value = var.cwagent.namespace
}
...

│ Error: Unsupported attribute
│ 
│   on optional_attributes/variables.tf line 22, in output "attributes":
│   22:   value = var.cwagent.namespace
│     ├────────────────
│     │ var.cwagent is a object, known only after apply
│ 
│ This object does not have an attribute named "namespace".
```

```hcl
output "attributes" {
  value = var.cwagent["namespace"]
}
...

 Error: Invalid index
│ 
│   on optional_attributes/variables.tf line 26, in output "attributes":
│   26:   value = var.cwagent["namespace"]
│     ├────────────────
│     │ var.cwagent is object with 3 attributes
│ 
│ The given key does not identify an element in this collection value.
```

```hcl
output "attributes" {
  value = lookup(var.cwagent, "namespace", "unknown")
}
...

Changes to Outputs:
  + object = "unknown"
```

```hcl
output "attributes" {
  value = keys(var.cwagent)
}
...

Changes to Outputs:
  + object = [
      + "enable",
      + "log_group",
      + "metrics_namespace",
    ]
```

**Conclusion**

* Attributes that are not defined in the object is ignored. 
* This means that there is no validation of the object attributes passed to the module.
* A typo on an attribute may causes things to behave differently than intended by the programmer that wrote the module.




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

