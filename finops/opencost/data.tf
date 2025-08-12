data "aws_iam_policy_document" "opencost-cur-access-policy" {

  statement {
    effect    = "Allow"
    actions   = ["athena:*"]
    resources = ["*"]
    sid       = "AthenaAccess"
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:GetDatabase*",
      "glue:GetTable*",
      "glue:GetPartition*",
      "glue:GetUserDefinedFunction",
      "glue:BatchGetPartition"
    ]
    resources = [
      "arn:aws:glue:*:*:catalog",
      "arn:aws:glue:*:*:database/athenacurcfn*",
      "arn:aws:glue:*:*:table/athenacurcfn*/*"
    ]
    sid = "ReadAccessToAthenaCurDataViaGlue"
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:PutObject"
    ]
    resources = ["*"]
    sid       = "AthenaQueryResultsOutput"
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [aws_s3_bucket.curcost.arn]  #need to specify bucket used in AWS CUR generation
    sid       = "S3ReadAccessToAwsBillingData"
  }

  statement {
    effect = "Allow"
    actions = [
      "organizations:ListAccounts",
      "organizations:ListTagsForResource"
    ]
    resources = ["*"] 
    sid       = "ReadAccessToAccountTags"
  }

}

#read region and account config 
data "aws_account_primary_contact" "test" {
  
}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
