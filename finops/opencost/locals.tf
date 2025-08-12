locals {
  unique_value = "${substr(data.aws_caller_identity.current.account_id, 8, 12)}-${data.aws_region.current.region}"
}
