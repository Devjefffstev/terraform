resource "helm_release" "main" {
  for_each   = var.helm_releases
  name       = each.key
  chart      = each.value.chart
  repository = try(each.value.repository,null)
  version    = try(each.value.version,null)
}
