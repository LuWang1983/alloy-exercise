resource "aws_ecr_repository" "technical_assessment" {
  name                 = "technical_assessment/echo-server"
  image_tag_mutability = "MUTABLE"

  tags = {
    project = var.project
  }
}
