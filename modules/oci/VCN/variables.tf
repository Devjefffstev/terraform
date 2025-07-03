variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment to create the VCN."

}

variable "cidr_blocks" {
  type        = list(string)
  description = "The list of one or more IPv4 CIDR blocks for the VCN."
}

variable "display_name" {
  type        = string
  description = "A user-friendly name. Does not have to be unique, and it's changeable."
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    dns_label  = optional(string, null)
  }))
  description = "The list of subnets to create in the VCN."
}
