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

resource "aws_security_group" "allow_http" {
  name   = "public web http"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

# enabled for validation
data "aws_key_pair" "example" {
  key_name           = "example"
  include_public_key = true
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.gold.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.primary_subnet.id
  # enabled for validation
  key_name      = data.aws_key_pair.example.key_name

  user_data_replace_on_change = true
  user_data                   = file("scripts/userdata.sh")

  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name} app instance"
  }
}
