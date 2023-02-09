/*==================
     AWS Lambda 
====================*/

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  #VPC main attributes and subnets
  name = "sysdev-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c", "${var.aws_region}d", "${var.aws_region}e", "${var.aws_region}f"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  #NAT gateway rules
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  #API endpoint
  enable_apigw_endpoint              = true
  apigw_endpoint_security_group_ids  = [module.general_sysdev_sg.this_security_group_id]
  apigw_endpoint_private_dns_enabled = true

  #ACL rules
  manage_default_network_acl = true
  default_network_acl_name = "sysdev-acl"
  default_network_acl_tags = {
    department = "sysdev"
  }

  tags = {
    department = "sysdev"
  }
}
