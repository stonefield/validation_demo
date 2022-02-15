# Dynamic Input Standard

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

[Version: ]

This is an example of using dynamic parameters with validations

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Usage](#usage)
- [Dynamic Inputs](#dynamic-inputs)
  - [cwagent](#cwagent)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Usage

<!-- BEGINNING OF PRE-COMMIT-BF-DYNAMIC-TERRAFORM DOCS HOOK -->
## Dynamic Inputs

### cwagent

CloudWatch agent specification

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| <a name="dynamic_enable"></a> [enable](#dynamic\_enable)  | Enable CloudWatch | bool | n/a |
| <a name="dynamic_os"></a> [os](#dynamic\_os)  | Operating system | string | "amazon_linux_2" |
| <a name="dynamic_dashboard"></a> [dashboard](#dynamic\_dashboard)  | Enable Dashboard | bool | true |
| <a name="dynamic_log_group"></a> [log_group](#dynamic\_log_group)  | Log group | map | n/a |
| <a name="dynamic_log_group.cluster"></a> [log_group.cluster](#dynamic\_log_group.cluster)  | Name of cluster or group | string | n/a |
| <a name="dynamic_log_group.role"></a> [log_group.role](#dynamic\_log_group.role)  | Role in cluster | string | n/a |
| <a name="dynamic_metrics_namespace"></a> [metrics_namespace](#dynamic\_metrics_namespace)  | Name of metric namespace for CloudWatch | string | n/a |

<!-- END OF PRE-COMMIT-BF-DYNAMIC-TERRAFORM DOCS HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_validation"></a> [validation](#module\_validation) | git@github.com:basefarm/terraform-aws-bf-utils//validation | v0.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cwagent"></a> [cwagent](#input\_cwagent) | CloudWatch agent specification | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attributes"></a> [attributes](#output\_attributes) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

