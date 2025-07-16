variable "helm_releases" {
  description = "List of Helm releases to be managed"
  type = map(object({    
    chart      = string
    version    = optional(string, null)
    create_namespace = optional(bool, true)
    repository = optional(string, null)
    namespace  = optional(string, null)
    values     = optional(list(string), null)
  }))  
}