variable "rg_prop_name_single" {
  description = "name of the single resource group"
  type        = string
  default     = null
}
variable "rg_prop_location_single" {
  description = "location of the single resource group"
  type        = string
  default     = null
}
variable "rg_prop_tags_single" {
  description = "tags for the single resource group"
  type        = map(string)
  default     = null
}
