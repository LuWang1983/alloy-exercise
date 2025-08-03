resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  # db subnet group requires 2 or more subnets, loop through the private subnets and add them in
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}
# At rest encryption and in-flight encryption which required AWS TLS root certificate
# Improvements: KMS encryption for extra security;
# use RDS proxy to improve performance to pool connections and reduce stress on the database instance; serverless and fully managed; enforce IAM auth; can never be accessed publicly
resource "aws_db_instance" "rds" {
  allocated_storage = 5
  engine            = "mysql"
  # see a list of supported engine and class at https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Support.html#gen-purpose-inst-classes
  engine_version = "8.0.39"
  instance_class = "db.m7i.large"
  db_name        = "alloy_exercise"
  # Alternatively, instead of password, use AWS managed master password stored in Secret Manager, KMS and IAM database authentication for extra layer of security
  manage_master_user_password         = true # When this is set to true, password cannot be used
  iam_database_authentication_enabled = true
  # master_user_secret_kms_key_id = aws_kms_key.rds.key_id
  username = var.db_username
  # password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # set to true to destroy resource without a final snapshot
  skip_final_snapshot = true
}
