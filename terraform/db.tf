resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  # db subnet group requires 2 or more subnets, loop through the private subnets and add them in
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_db_instance" "rds" {
  allocated_storage = 5
  engine            = "mysql"
  # see a list of supported engine and class at https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Support.html#gen-purpose-inst-classes
  engine_version         = "8.0.39"
  instance_class         = "db.m7i.large"
  db_name                = "alloy_exercise"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # set to true to destroy resource without a final snapshot
  skip_final_snapshot = true
}
