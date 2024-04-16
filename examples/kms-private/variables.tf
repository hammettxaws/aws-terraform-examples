variable "aws_region" {
  description = "AWS Region to utilize"
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Name of the project"
  default     = "tfkms"
}

variable "vpc_cidr" {
  description = "CIDR for the project VPC"
  default     = "172.37.0.0/16"
}

variable "root_user" {
  description = "root user or administrator"
}

variable "public_cidr" {
  description = "public ip cidr address of organization"
}