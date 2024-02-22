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

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name} igw"
  }
}

resource "aws_route_table" "routes" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name} routes"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = 1
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.routes.id
}

# enabled for validation
data "aws_key_pair" "example" {
  key_name           = "example"
  include_public_key = true
}

resource "aws_security_group" "allow_ssh" {
  name   = "public web ssh"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_instance" "gold" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.primary_subnet.id
  # enabled for validation
  key_name      = data.aws_key_pair.example.key_name

  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = file("scripts/userdata.sh")

  tags = {
    Name = "${var.project_name} gold instance"
  }
}

resource "aws_ami_from_instance" "web-ami" {
  name               = "web-ami-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  source_instance_id = aws_instance.gold.id

  depends_on = [
    aws_instance.gold,
  ]

  tags = {
    Name = "gold-ami"
  }
}
