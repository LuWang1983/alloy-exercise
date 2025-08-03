# Note: roles are assumed by machines, in this case, the ec2 instance
resource "aws_iam_role" "ec2_role_echo_server" {
  name = "ec2_role_echo_server"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )

  tags = {
    project = var.project
  }
}

# profile for ec2 to attach the role and policy
resource "aws_iam_instance_profile" "ec2_profile_echo_server" {
  name = "ec2_profile_echo_server"
  role = aws_iam_role.ec2_role_echo_server.name
}

# (Optional) Allow the role to get docker image from the container registry
resource "aws_iam_role_policy" "allow_ecr" {
  name = "allow_ecr"
  role = aws_iam_role.ec2_role_echo_server.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:aws:ecr:${var.region}:${var.repository}"
        }
      ]
  })
}

# (Optional if username and password is used) Assign the role to connect to the RDS database
resource "aws_iam_role_policy" "connect_rds" {
  name = "connect_rds"
  role = aws_iam_role.ec2_role_echo_server.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "rds-db:connect"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.rds.id}/${var.db_username}"
      }
    ]
  })
}
# (Optional if username and password is used) Same role to read and write to the database
resource "aws_iam_role_policy" "manage_rds" {
  name = "manage_rds"
  role = aws_iam_role.ec2_role_echo_server.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "rds:DescribeDBInstances",
          "rds:StartDBInstance",
          "rds:StopDBInstance",
          "rds:RebootDBInstance",
          "rds:ModifyDBInstance",
          "rds:DeleteDBInstance",
        ],
        "Effect" : "Allow",
        "Resource" : "${aws_db_instance.rds.arn}",
      }
    ]
  })
}
