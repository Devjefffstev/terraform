locals {
  # Define the AWS IAM role for EKS cluster
  this_aws_iam_role = {
    for role_policy, role_details in var.this_aws_iam_role : role_policy => merge(role_details, {
      assume_role_policy = file("${path.module}/${role_details.assume_role_policy}")
    })

  }
  subnets_created_ids = [for subnet in module.aws_vpc.subnet_properties : subnet.id]
}
