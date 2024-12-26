## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_subnet.main](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.main](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | The list of one or more IPv4 CIDR blocks for the VCN. | `list(string)` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment to create the VCN. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | A user-friendly name. Does not have to be unique, and it's changeable. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets to create in the VCN. | <pre>map(object({<br>    cidr_block = string<br>    dns_label  = optional(string, null)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets_properties"></a> [subnets\_properties](#output\_subnets\_properties) | n/a |
| <a name="output_vcn_properties"></a> [vcn\_properties](#output\_vcn\_properties) | n/a |
