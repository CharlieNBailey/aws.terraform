resource "aws_vpc" "main" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}
resource "aws_subnet" "cnb_public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "dev-public"
  }
}
resource "aws_internet_gateway" "cnb_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw"
  }
}
resource "aws_route_table" "cnb_public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev_public_rt"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.cnb_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cnb_igw.id
}
resource "aws_route_table_association" "cnb_public_assoc" {
  subnet_id      = aws_subnet.cnb_public_subnet.id
  route_table_id = aws_route_table.cnb_public_rt.id
}
resource "aws_security_group" "cnb_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["82.46.218.170/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "cnb_auth" {
  key_name   = "cnb_key"
  public_key = file("~/.ssh/cnb_key.pub")
}
resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.cnb_auth.id
  vpc_security_group_ids = [aws_security_group.cnb_sg.id]
  subnet_id              = aws_subnet.cnb_public_subnet.id
  user_data              = file("userdata.tpl")
  tags = {
    Name = "dev-node"

  }
  root_block_device {
    volume_size = 10
  }
}