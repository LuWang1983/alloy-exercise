# backend configuration file config.remote.tfbackend
# terraform init -backend-config=config.remote.tfbackend
workspaces { name = "<WORKSPACE_NAME>" }
hostname     = "<HOSTNAME>"
organization = "<ORG_NAME>"


# Remote backend configuration
# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "<HOSTNAME>"
    organization = "<ORG_NAME>"

    workspaces {
      name = "<WORKSPACE_NAME>"
    }
  }
}

# Using multiple workspaces:
terraform {
  backend "remote" {
    hostname     = "<HOSTNAME>"
    organization = "<ORG_NAME>"

    workspaces {
      prefix = "my-app-"
    }
  }
}

# S3 backend configuration
terraform {
  backend "s3" {
    bucket = "<UNIQUE_BUCKET_NAME>"
    key    = "<PATH/*/*>"
    region = "<REGION>"
  }
}
