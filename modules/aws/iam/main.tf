resource "aws_iam_role" "main" {
  for_each           = var.aws_iam_role
  name               = each.key
  assume_role_policy = each.value.assume_role_policy
}
resource "aws_iam_role_policy_attachment" "main" {
  for_each   = local.aws_iam_role_policy_attachment
  policy_arn = each.value.policy_arn
  role       = each.value.role
  depends_on = [ aws_iam_role.main ]
}

