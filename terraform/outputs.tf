output "public_ip" {
  description = "The public IP address of the echo server"
  value       = aws_eip.ec2_eip[0].public_ip
  depends_on  = [aws_eip.ec2_eip]
}

output "public_dns" {
  description = "The public DNS address of the echo server"
  value       = aws_eip.ec2_eip[0].public_dns
  depends_on  = [aws_eip.ec2_eip]
}


output "database_address" {
  description = "The address of the database"
  value       = aws_db_instance.rds.address
}

output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.rds.port # default port for MySQL is 3306
}

output "master_user_secret" {
  description = "AWS managed password stored in Secret Manager. This includes kms_key_id, secret_arn and secret_status."
  value       = aws_db_instance.rds.master_user_secret
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
