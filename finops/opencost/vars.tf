# Define AWS access key and secret key variables
# variable "aws_access_key" {
#   description = "AWS Access Key"
#   type        = string

# }
# variable "aws_secret_key" {
#   description = "AWS Secret Key"
#   type        = string
# }
variable "aws_profile" {
  description = "AWS Profile"
  type        = string
  default     = "default"
}
variable "principal_arn_user" {
  description = "The ARN of the user to bind the role to"
  type        = string
}