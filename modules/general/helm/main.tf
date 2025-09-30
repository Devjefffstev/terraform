resource "helm_release" "main" {
  for_each         = var.helm_releases
  name             = each.key
  chart            = each.value.chart
  namespace        = try(each.value.namespace, null)
  create_namespace = try(each.value.create_namespace, null)
  repository       = try(each.value.repository, null)
  version          = try(each.value.version, null)
  values           = try(each.value.values, null)
  cleanup_on_fail  = try(each.value.cleanup_on_fail, null)
  atomic           = try(each.value.atomic, null)
  timeout          = try(each.value.timeout, null)
}
