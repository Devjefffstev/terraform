resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

resource "aws_subnet" "main" {
  for_each   = local.subnets
  vpc_id     = each.value.vpc_id
  cidr_block = each.value.cidr_block 
  availability_zone = each.value.availability_zone
  tags = each.value.tags
}
