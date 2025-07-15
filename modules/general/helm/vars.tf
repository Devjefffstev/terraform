variable "helm_releases" {
  description = "List of Helm releases to be managed"
  type = list(object({
    name       = string
    chart      = string
    version    = optional(string, null)
    namespace  = optional(string, "default")
    values     = optional(map(any), {})
    depends_on = optional(list(string), [])
  }))
  default = []
  
}