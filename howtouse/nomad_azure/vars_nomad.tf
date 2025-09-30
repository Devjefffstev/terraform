variable "nomad_secret" {
  type    = string
  default = "f6b8c012-a851-7dc1-eaaa-b32302284fdd"
}

variable "nomad_binary" {
  description = "URL of a zip file containing a nomad executable to replace the Nomad binaries in the AMI with. Example: https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"
  default     = "https://releases.hashicorp.com/nomad/1.10.4/nomad_1.10.4_linux_amd64.zip"
}

variable "azuread_application_registration_client_id" {
  type = string

}

variable "azuread_application_registration_client_secret" {
  type = string

}

variable "nomad_id" {
  type    = string
  default = "2f3fee4d-2216-8345-05e2-4e265d3588b8"
}
variable "nomad_version" {
  description = "The version of the Nomad binary to install."
  default     = "1.5.0"
}

locals {
  retry_join = "provider=azure tag_name=ConsulAutoJoin tag_value=auto-join subscription_id=${data.azurerm_client_config.current.subscription_id} tenant_id=${data.azurerm_client_config.current.tenant_id} client_id=${var.azuread_application_registration_client_id} secret_access_key='${var.azuread_application_registration_client_secret}'"

  deployment_region = "eastus"
}