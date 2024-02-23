variable "aws_region" {
  description = "AWS Region to utilize"
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Name of the project"
  default     = "tfapp"
}

variable "vpc_cidr" {
  description = "CIDR for the project VPC"
  default     = "172.35.0.0/16"
}

variable "subnet_cidr_block" {
  description = "Available cidr block for public subnets."
  default     = "172.35.1.0/24"
}

variable "instance_type" {
  description = "The instance type to use"
  default = "t3.micro"
}
