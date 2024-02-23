data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "gold" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["web-ami-*"]
  }
}
