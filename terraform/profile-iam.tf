# Note: roles are assumed by machines, in this case, the ec2 instance
resource "aws_iam_role" "ec2_role_echo_server" {
  name = "ec2_role_echo_server"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    project = var.project
  }
}

# profile for ec2 to attach the role and policy
resource "aws_iam_instance_profile" "ec2_profile_echo_server" {
  name = "ec2_profile_echo_server"
  role = aws_iam_role.ec2_role_echo_server.name
}

# Allow the role to get docker image from the container registry
# Optionally, assign the role to get read/write to the RDS database
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role_echo_server.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ecr:${var.region}:${var.repository}"
    }
  ]
}
EOF
}
