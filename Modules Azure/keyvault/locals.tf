locals {
  access_policy = [
    for access_policy in var.access_policy : merge(access_policy, {
      tenant_id = var.tenant_id
    })
  ]
}
