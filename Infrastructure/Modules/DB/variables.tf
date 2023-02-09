variable "environment_name" {
  description = "The name of your environment"
  type        = string
}

variable "private_subnets_id" {
  description = "Subnet ID in which ecs will deploy the tasks"
  type        = list(string)
}

variable "cidr_block" {
  description = "Allowed Cidr block string "
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC cidr blockk"
  type        = string
}

variable "security_group" {
  description = "Subnet ID in which ecs will deploy the tasks"
  type        = list(string)
}

variable "db_size" {
  description = "The size of the DB"
  type        = string
  default     = "db.t3.medium"
}
