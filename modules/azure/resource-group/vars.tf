variable "resource_group_prop" {
  description = "values for resource group properties. Use the key as the name of the resource group"
  type = map(object({
    location = string
    tags     = optional(map(string), {})
  }))
  default = {}

}
