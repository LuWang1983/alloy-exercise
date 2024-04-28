variable "project" {
  type        = string
  description = "The project name for the resources"
}

variable "region" {
  type = string
}

variable "image_name" {
  type        = string
  description = "The docker image that runs the echo server"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for vpc"
  # supports 256 IP addresses
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  # for addresses 10.0.0.0 - 10.0.0.127
  default = [
    "10.0.0.0/25",
    "10.0.0.1/25",
    "10.0.0.2/25",
    "10.0.0.3/25",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  # for addresses 10.0.0.128 - 10.0.0.255
  default = [
    "10.0.0.252/25",
    "10.0.0.253/25",
    "10.0.0.254/25",
    "10.0.0.255/25",
  ]
}
variable "registry" {
  type        = string
  description = "AWS registry address"
}

variable "repository" {
  type        = string
  description = "AWS ECR repository"
}


variable "instance_number" {
  description = "The number of EC2 instances"
  type        = number
  default     = 1
}

variable "my_ip" {
  description = "The IP address allowed to SSH into the EC2 instances"
  type        = string
  sensitive   = true
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "public_key_path" {
  type      = string
  sensitive = true
}
