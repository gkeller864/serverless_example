/*=======================================
      Amazon RDS resources
========================================*/

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name               = "${var.environment_name}-cluster"
  engine             = "aurora-postgres"
  engine_version     = "13.7postgres:20.4"
  instance_class     = var.db_size
  instances = {
    1 = {}
    2 = {}
      }
  
  autoscaling_enabled      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 1

  vpc_id  = var.vpc_id
  subnets = var.private_subnets_id

  allowed_security_groups = var.security_group
  allowed_cidr_blocks     = var.cidr_block

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  skip_final_snapshot = true

  db_parameter_group_name         = "default.aurora-postgres10"
  db_cluster_parameter_group_name = "default-aurora57-postgres"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

}