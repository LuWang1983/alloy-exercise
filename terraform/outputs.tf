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
  value       = aws_db_instance.rds.port
}
