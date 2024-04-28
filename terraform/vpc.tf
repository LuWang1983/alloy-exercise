resource "aws_vpc" "echo_server" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "echo_server"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.echo_server.id
  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_eip" "ec2_eip" {
  count = var.instance_number
  # use list and index to be more scalable
  instance   = aws_instance.alloy_exercise[count.index].id
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "ec2-eip-${count.index}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.echo_server.id
  count                   = 1
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${data.aws_availability_zones.available.names[count.index]}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.echo_server.id
  count                   = 2
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = element(var.private_subnet_cidr_blocks, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${data.aws_availability_zones.available.names[count.index]}-private"
  }
}

