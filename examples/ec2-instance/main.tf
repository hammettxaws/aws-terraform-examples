resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "primary_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name} subnet"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.primary_subnet.id

  tags = {
    Name = "${var.project_name} web instance"
  }
}