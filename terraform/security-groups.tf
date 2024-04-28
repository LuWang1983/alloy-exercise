# Security group for Application EC2 instances in public subnet
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group to allow https/http requests from the internet."
  vpc_id      = aws_vpc.echo_server.id
  depends_on  = [aws_vpc.echo_server]
  ingress {
    description = "Allow all inbound traffic via https"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow all inbound traffic via https"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH from a specific IP"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.my_ip}/32"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "name" = "security_group_public"
  }
}

# Security group for RDS in private subnet
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group to allow requests from the ec2 instances."
  vpc_id      = aws_vpc.echo_server.id
  depends_on  = [aws_vpc.echo_server]
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  tags = {
    "name" = "security_group_private"
  }
}
