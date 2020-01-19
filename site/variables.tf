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

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  # AWS recommends a 192.168.0.0/16 for 65k IPs in EKS
  # It recommends each subnet has 16k (a.b.c.0/18) IPs for EKS
  # But we need to start with 4 subnets (potentially more)
  # Suggest 172.20.0.0/16 for 65k IPs
  # This allows for 4 subnets of 8k each with 32k IPs still available
  description = "CIDR for the whole VPC"
  default = "172.20.0.0/16"
}

variable "ip_range" {
  default = "95.147.105.79/32"
}

variable "newbits" {
  # cidrsubnet(prefix, newbits, netnum)
  # With a 172.20.0.0/16 cidr, newbits of 2 => 16k IPs, 3 => 8k, 2 => 4k
  description = "newbits for the cidr"
  default = "3"
}

variable "subnets" {
  default = ["us-east-1a","us-east-1b","us-east-1c",]
}