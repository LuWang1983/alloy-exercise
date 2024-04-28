data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
# Alternatively, we can use aws autoscaling group and launch_template to provision the EC2 instance
resource "aws_instance" "alloy_exercise" {
  count         = var.instance_number
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[count.index].id
  key_name      = aws_key_pair.ssh.key_name

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = 8
  }

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    
    # pull echo-server docker image
    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.registry}
    docker pull ${var.image_name}
    docker run -itp 3246:3246 ${var.image_name}
  EOF

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_echo_server.name

  tags = {
    project = var.project
  }

  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true

  depends_on = [aws_ecr_repository.technical_assessment]
}

