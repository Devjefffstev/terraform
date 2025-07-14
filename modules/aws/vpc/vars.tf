variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string 
}
variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}  
}
variable "subnets" {
  type = list(object({
    cidr_block        = string
    tags              = optional(map(string), {})
    availability_zone = optional(string, null)
    map_public_ip_on_launch = optional(bool, null)
  }))
}
