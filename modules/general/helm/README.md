<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.main](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_releases"></a> [helm\_releases](#input\_helm\_releases) | List of Helm releases to be managed | <pre>map(object({<br/>    chart            = string<br/>    version          = optional(string, null)<br/>    create_namespace = optional(bool, true)<br/>    repository       = optional(string, null)<br/>    namespace        = optional(string, null)<br/>    values           = optional(list(string), null)<br/>    cleanup_on_fail  = optional(bool, true)<br/>    atomic           = optional(bool, true)<br/>    timeout          = optional(string, 300)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_releases"></a> [helm\_releases](#output\_helm\_releases) | n/a |
<!-- END_TF_DOCS -->