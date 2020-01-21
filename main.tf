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

provider "aws" {
  region = var.region
}

module "site" {
  source = "./site"
  cluster_name = "${var.cluster_name}"
}

module "security" {
  source = "./security"
  vpc_id = "${module.site.vpc_id}"
  public_subnets = "${module.site.public_subnets}"
  public_cidr_blocks = "${module.site.public_cidr_blocks}"
  private_subnets = "${module.site.private_subnets}"
  private_cidr_blocks = "${module.site.private_cidr_blocks}"
}