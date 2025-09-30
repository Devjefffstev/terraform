output "helm_releases" {
  value     = helm_release.main
  sensitive = true
}