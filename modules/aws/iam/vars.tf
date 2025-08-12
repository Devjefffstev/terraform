variable "aws_iam_role" {
  description = "IAM role for general use"
  type = map(object({
    # name               = string
    assume_role_policy = string
    ## Attirbutes for aws_iam_role_policy_attachment
    aws_iam_role_policy_attachment = list(object({
      policy_arn = optional(string, null)
    #   role  = optional(string, null)
    }))
  }))
}
