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
    os        = "amazon_linux"
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
```ShellSession
│ Error: Invalid value for module argument
│
│   on test.tf line 3, in module "object":
│    3:   cwagent = {
│    4:     enable    = true
│    5:     os        = "amazon_linux"
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
    os        = "amazon_linux"
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
```ShellSession
Changes to Outputs:
  + object = {
      + "enable"    = "true"
      + "namespace" = "my-asg"
      + "os"        = "amazon_linux"
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
    os        = "amazon_linux"
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
```ShellSession
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
    os        = "amazon_linux"
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
```ShellSession
Changes to Outputs:
  + object = {
      + enable            = true
      + log_group         = {
          + cluster = "my-cluster"
          + role    = "my-role"
        }
      + metrics_namespace = "my-asg"
      + os                = "amazon_linux"
    }
```

### 2.3 object with attributes defined, but one attribute is missing

Main module:
```hcl
module "object" {
  source = "./object_defined"
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
```

Result:
```ShellSession
Error: Invalid value for module argument
│
│   on test.tf line 3, in module "object":
│    3:   cwagent = {
│    4:     enable    = true
│    5:     os        = "amazon_linux"
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

### 2.4 object with optional attributes defined

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
    os        = "amazon_linux"
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
```ShellSession
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
```
```ShellSession
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
```
```ShellSession
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
```
```ShellSession
Changes to Outputs:
  + object = "unknown"
```

```hcl
output "attributes" {
  value = keys(var.cwagent)
}
```
```ShellSession
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


## 3. Variable without type specification

### 3.1 Basic definition

Sub-module `unspecified`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
}

output "attributes" {
  value = var.cwagent
}
```

Main module
```hcl
module "object" {
  source = "./unspecified"
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
```


Result:
```ShellSession
Changes to Outputs:
  + object = {
      + enable    = true
      + log_group = {
          + cluster = "my-cluster"
          + role    = "my-role"
        }
      + namespace = "my-asg"
      + os        = "amazon_linux"
    }
```

As we can see, all attributes passed to the submodule are present.

### 3.1 Lets add some validation of the keys

Sub-module `unspecified_with_keys_validation`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  #source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.0"
  source = "../../../terraform-aws-bf-utils//validation"
  module   = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
    }
  }
}


output "attributes" {
  value = var.cwagent
}
```

Main module
```hcl
module "object" {
  source = "./unspecified"
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
```

Result:
```ShellSession
│ Error: failed to execute "../../terraform-aws-bf-utils/validation/validate":
│
│ ----------------------------------------------------------------------------------
│ VALIDATION FAILED in module: unspecified_with_keys_validation
│ - Invalid key(s) in cwagent: namespace. Valid keys are: os,enable,log_group,metrics_namespace
│ -
│
│  Ensure variables are valid.
│  You can ignore the error following this message until you have fixed your parameters.
│ ----------------------------------------------------------------------------------
│
│
│   with module.object.module.validation.data.external.validation[0],
│   on ../../terraform-aws-bf-utils/validation/main.tf line 1, in data "external" "validation":
│    1: data "external" "validation" {
```

**Conclusion**

* Now we can detect a typo from the user of the module. `namespace` is not a valid key.
* But, with this, we may still miss some parameters, so lets add some more validation.


### 3.2 Lets add some validation that validates presence of keys

Sub-module: `unspecified_with_presence_validation`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  #source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.0"
  source = "../../../terraform-aws-bf-utils//validation"
  module   = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
      presence = "enable,metrics_namespace"
    }
  }
}


output "attributes" {
  value = var.cwagent
}

```

Main module
```hcl
module "object" {
  source = "./unspecified_with_presence_validation"
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
```

Result:
```ShellSession
│ Error: failed to execute "../../terraform-aws-bf-utils/validation/validate":
│
│ ----------------------------------------------------------------------------------
│ VALIDATION FAILED in module: unspecified_with_presence_validation
│ - Invalid key(s) in cwagent: namespace. Valid keys are: os,enable,log_group,metrics_namespace
│ - Missing keys in cwagent: metrics_namespace.
│ -
│
```

### 3.3 Fix errors

Main module
```hcl
module "object" {
  source = "./unspecified_with_presence_validation"
  cwagent = {
    enable    = true
    os        = "amazon_linux"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    metrics_namespace = "my-asg"
  }
}

output "object" {
  value = module.object.attributes
}
```

Result:
```ShellSession
Changes to Outputs:
  + object = {
      + enable            = true
      + log_group         = {
          + cluster = "my-cluster"
          + role    = "my-role"
        }
      + metrics_namespace = "my-asg"
      + os                = "amazon_linux"
    }
```

### 3.3 Lets add some assertions on content of the attributes

Sub-module: `validation_with_assert`
```hcl
variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  #source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.0"
  source = "../../../terraform-aws-bf-utils//validation"
  module   = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
      presence = "enable,metrics_namespace"
    }
  }
  assert = [
    [can(regex("amazon_linux_2|ubuntu", var.cwagent.os)), "Operating system (os) must be amazon_linux_2 OR ubuntu."]
  ]
}


output "attributes" {
  value = var.cwagent
}
```

Result:
```ShellSession
│ Error: failed to execute "../../terraform-aws-bf-utils/validation/validate":
│
│ ----------------------------------------------------------------------------------
│ VALIDATION FAILED in module: validation_with_assert
│ -
│ - Operating system (os) must be amazon_linux_2 OR ubuntu.
│
│  Ensure variables are valid.
│  You can ignore the error following this message until you have fixed your parameters.
│ ----------------------------------------------------------------------------------
│
│
│   with module.object.module.validation.data.external.validation[0],
│   on ../../terraform-aws-bf-utils/validation/main.tf line 1, in data "external" "validation":
│    1: data "external" "validation" {
│
```


**Validation is not perfect**

* Values that are depending on data or calculated values cannot be validated,
  as terraform will fail before validation is run
