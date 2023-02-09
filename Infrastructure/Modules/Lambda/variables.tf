variable "name" {
  description = "The name of your security group"
  type        = string
}

variable "description" {
  description = "A description of the purpose"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the lambda resides"
  type        = string
}
