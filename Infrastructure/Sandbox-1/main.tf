/*===========================
          Root file
============================*/
# ------- Providers -------
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  # provider level tagging
   default_tags {
     tags = {
       Created_by = "Terraform"
       Project    = "AWS_${var.environment_name}_devops"
     }
   }
}

# ------- Account ID -------
data "aws_caller_identity" "id_current_account" {}

# ------- Lambda Creation -------
module "vpc" {
  source              = "../Modules/VPC"
  name                = "${var.environment_name}-VPC"
  vpc_cidr            = "10.0.0.0/16"
  aws_region          = var.aws_region
  private_subnets     = ["10.0.4.0/24","10.0.6.0/24"]
  public_subnets      = ["10.0.2.0/24","10.0.1.0/24"]
  security_group_ids  = module.security_group_id
}

# ------- Creating Api Gateway Public -------
module "alb_app" {
  source                = "../Modules/API_Gateway"
  name                  = "${var.environment_name}-public"
}

# ------- Creating Api Gateway Private -------
module "alb_app" {
  source                = "../Modules/API_Gateway"
  name                  = "${var.environment_name}-private"
}

# ------- Creating ALB -------
module "alb_app" {
  source                = "../Modules/ALB"
  create_alb            = true
  name                  = "${var.environment_name}-app"
  subnet                = module.vpc.public_subnet_id
  security_group        = [module.security_group_alb.sg_id]
}

# ------- Creating Security Group for the  ALB -------
module "security_group_alb" {
  source              = "../Modules/SecurityGroup"
  name                = "alb-${var.environment_name}"
  description         = "Controls access to the ALBs"
  vpc_id              = module.vpc.vpc_id
  cidr_blocks_ingress = ["0.0.0.0/0"]
  ingress_port        = 8080
}

# ------- Lambda Creation -------
module "lambda" {
  source              = "../Modules/Lambda"
  name                = "${var.environment_name}-lambda"
  description         = "Lambda for application"
  security_group_ids  = module.private_subnet_sg.subnet_id
  subnet_ids          = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}

# ------- Creating Security Group for the Lambda -------
module "security_group_lambda" {
  source              = "../Modules/SecurityGroup"
  name                = "${var.environment_name}-lambda"
  description         = "Controls access to the Lambdas"
  vpc_id              = module.vpc.vpc_id
  cidr_blocks_ingress = ["10.0.4.0/24","10.0.5.0/24"]
  ingress_port        = 80
}

# ------- Creating SQL DB for the Back-end -------
module "database_cluster" {
  source           = "../Modules/DB"
  environment_name = "${var.environment_name}-db"
  vpc_id           = module.vpc.vpc_id
  security_group   = [module.security_group_db_server.sg_id]
  subnets_id       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  cidr_block       = ["10.0.0.0/16"]
}

# ------- Creating SG for the RDS server -------
module "security_group_db_server" {
  source              = "../Modules/SecurityGroup"
  name                = "${var.environment_name}-db"
  description         = "Controls access to the DB Server"
  vpc_id              = module.vpc.vpc_id
  ingress_port        = 5432
}

