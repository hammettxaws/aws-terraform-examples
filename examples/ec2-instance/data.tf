data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_key_pair" "key" {
  key_name           = var.key_name
  include_public_key = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
