variable "aws_region" {
  description = "AWS Region to utilize"
  default     = "ap-southeast-2"
}

variable "key_name" {
  description = "The EC2 key name to use. Must be available"
  default     = "example"
}

variable "instance_type" {
  description = "The instance type to use"
  default = "t3.micro"
}

variable "project_name" {
  description = "Name of the project"
  default     = "tfinstance"
}

variable "vpc_cidr" {
  description = "CIDR for the project VPC"
  default     = "172.34.0.0/16"
}

variable "subnet_cidr_block" {
  description = "Available CIDR block for public subnets."
  default     = "172.34.1.0/24"
}
