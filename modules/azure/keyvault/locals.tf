locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"

  key_vault_secrets = {
    for key_secret, secret in var.key_vault_objects : key_secret => secret
    if secret.value != null
  }
  key_vault_certificates = {
    for key_cert, cert in var.key_vault_objects : key_cert => cert
    if cert.certificate_data != null && cert.password != null
  }
}
