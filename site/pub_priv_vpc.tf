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

resource "aws_vpc" "rst" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
      Name = "rst_vpc"
  }
}

resource "aws_internet_gateway" "rst" {
  vpc_id = aws_vpc.rst.id
  tags = {
      Name = "rst_igw"
  }
}
output "vpc_id" {
  value = aws_vpc.rst.id
}

### NAT Instance todo

#
# Subnets
#

resource "aws_subnet" "rst_pub_subnets" {
  vpc_id = aws_vpc.rst.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index)
  availability_zone = var.subnets[count.index]
  tags = {
    Name = "rst_public_subnet_${var.subnets[count.index]}"
  }
}

resource "aws_subnet" "rst_prv_subnets" {
  vpc_id = aws_vpc.rst.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index+4)
  tags = {
    Name = "rst_private_subnet_${var.subnets[count.index]}"
    availability_zone = var.subnets[count.index]
  }
}

/* data "aws_subnet" "rst_pub_subnets" {
  
  count = length(var.subnets)
  
  filter {
    Name = "rst_public_subnet_${var.subnets[count.index]}"
  }

  id[count.index] = data.aws_subnet.rst_pub_subnets.id[count.index]

} */

resource "aws_route_table" "rst_pub_rt" {
  vpc_id = aws_vpc.rst.id

  count = length(var.subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rst.id
  }
  tags = {
    Name = "rst_public_route_table_${var.subnets[count.index]}"
  }
}

locals {
  rst_pub_subnets_ids = aws_subnet.rst_pub_subnets.*.id
  rst_pub_rt_ids = aws_route_table.rst_pub_rt.*.id
  rst_priv_subnets_ids = aws_subnet.rst_prv_subnets.*.id
}


resource "aws_route_table_association" "rst_pub_subnets" {
  count = length(local.rst_pub_rt_ids)

  subnet_id = local.rst_pub_subnets_ids[count.index]
  route_table_id = local.rst_pub_rt_ids[count.index]
}