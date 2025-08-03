terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.8.0"
}

provider "aws" {
  region = var.region
}

# Use available for this exercise but in real world, often needs to specify a region
data "aws_availability_zones" "available" {
  state = "available"
}
