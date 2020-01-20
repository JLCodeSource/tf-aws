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

resource "aws_vpc" "trt" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
      Name = "trt_vpc"
  }
}

resource "aws_internet_gateway" "trt" {
  vpc_id = aws_vpc.trt.id
  tags = {
      Name = "trt_igw"
  }
}
output "vpc_id" {
  value = aws_vpc.trt.id
}

### NAT Instance todo

#
# Subnets
#

resource "aws_subnet" "trt_pub_subnets" {
  vpc_id = aws_vpc.trt.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index)
  availability_zone = var.subnets[count.index]
  tags = {
    Name = "trt_public_subnet_${var.subnets[count.index]}"
  }
}

resource "aws_subnet" "trt_prv_subnets" {
  vpc_id = aws_vpc.trt.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index+4)
  tags = {
    Name = "trt_private_subnet_${var.subnets[count.index]}"
    availability_zone = var.subnets[count.index]
  }
}

resource "aws_route_table" "trt_pub_rt" {
  vpc_id = aws_vpc.trt.id

  count = length(var.subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trt.id
  }
  tags = {
    Name = "trt_public_route_table_${var.subnets[count.index]}"
  }
}

resource "aws_route_table" "trt_prv_rt" {
  vpc_id = aws_vpc.trt.id

  count = length(var.subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trt.id
  }
  tags = {
    Name = "trt_prv_route_table_${var.subnets[count.index]}"
  }
}


locals {
  trt_pub_subnets_ids = aws_subnet.trt_pub_subnets.*.id
  trt_pub_rt_ids = aws_route_table.trt_pub_rt.*.id
  trt_prv_subnets_ids = aws_subnet.trt_prv_subnets.*.id
  trt_prv_rt_ids = aws_route_table.trt_prv_rt.*.id
}


resource "aws_route_table_association" "trt_pub_subnets" {
  count = length(local.trt_pub_rt_ids)

  subnet_id = local.trt_pub_subnets_ids[count.index]
  route_table_id = local.trt_pub_rt_ids[count.index]
}

resource "aws_route_table_association" "trt_prv_subnets" {
  count = length(local.trt_prv_rt_ids)

  subnet_id = local.trt_prv_subnets_ids[count.index]
  route_table_id = local.trt_prv_rt_ids[count.index]
}