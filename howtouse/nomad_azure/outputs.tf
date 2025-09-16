output "private_key" {
  value     = tls_private_key.example_ssh
  sensitive = true
}
