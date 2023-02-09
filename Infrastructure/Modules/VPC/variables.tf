variable "name" {
  description = "The name of your security group"
  type        = string
}

variable "description" {
  description = "A description of the purpose"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will take place"
  type        = string
}

variable "security_groups" {
  description = "List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC"
  type        = list(any)
  default     = null
}
