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

resource "aws_iam_instance_profile" "ec2_profile_echo_server" {
  name = "ec2_profile_echo_server"
  role = aws_iam_role.ec2_role_echo_server.name
}

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
