resource "aws_vpc" "echo_server" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "echo_server"
  }
}

####### Optional #########
# Notes: An internet gateway facilitates communication between a Virtual Private Cloud (VPC) and the internet.
# It acts as a target in your VPC route tables for internet-routable traffic.
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.echo_server.id
  tags = {
    Name = "internet_gateway"
  }
}
# Assign a static public IP or let EC2 decides its own depends on use case
# Note: Either associate the public IP with an instance or ENI, not both
resource "aws_eip" "ec2_eip" {
  count = var.instance_number
  # use list and index to be more scalable
  instance = aws_instance.alloy_exercise[count.index].id
  # Utilized network interface resource to attach a static ip
  # network_interface = aws_network_interface.alloy_eni.id
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "ec2-eip-${count.index}"
  }
}
####### Optional #########

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.echo_server.id
  count                   = 1
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true # Automatically assign public IPs to instances

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

# Improvements: attach an ENI to the instance to manager the network configs separately from the instance.
# Multiple ENIs limit scope and isolate different types of traffic; security, failover, availability etc.
resource "aws_network_interface" "alloy_eni" {
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.ec2_sg.id]

  attachment {
    instance     = aws_instance.alloy_exercise.id
    device_index = 0
  }
}

resource "aws_network_interface_attachment" "alloy_eni" {
  instance_id          = aws_instance.alloy_exercise.id
  network_interface_id = aws_network_interface.alloy_eni.id
  device_index         = 0
}
