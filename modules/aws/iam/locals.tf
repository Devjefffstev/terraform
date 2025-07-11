locals {
  aws_iam_role_policy_attachment = { for irpa in flatten([
    for irp, prop in var.aws_iam_role : [
      for ipa in prop.aws_iam_role_policy_attachment : {
        policy_arn = ipa.policy_arn
        role       = irp       
        index = index(prop.aws_iam_role_policy_attachment, ipa)
      }
    ]
    ]) : "index-${irpa.index}-${irpa.policy_arn}" => irpa
  }
}
