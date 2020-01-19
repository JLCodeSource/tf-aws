# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.

resource "aws_vpc" "support" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
      Name = "terraform_vpc"
  }
}

resource "aws_internet_gateway" "support" {
  vpc_id = aws_vpc.support.id
  tags = {
      Name = "terraform_igw"
  }
}
output "vpc_id" {
  value = aws_vpc.support.id
}

### NAT Instance todo

#
# Subnets
#

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.support.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index)
  tags = {
    Name = "Public Subnet ${var.region}${var.az_num[count.index]}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.support.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index+4)
  tags = {
    Name = "Private Subnet ${var.region}${var.az_num[count.index]}"
  }
}