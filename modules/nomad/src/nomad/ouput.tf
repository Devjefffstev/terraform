output "nomad-server-vm" {
  value     = module.nomad-client.resource
  sensitive = true
}

output "nomad-client-vm" {
  value     = module.nomad-client.resource
  sensitive = true
}