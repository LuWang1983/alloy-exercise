## Context
An exercise based on the following prompt:

- Compute infrastructure within AWS that an application could eventually run on. 
- A data store in AWS, that the compute infrastructure can communicate with. 

## Pre-requisites
- AWS cli
- Terraform cli
- Docker 

## Considerations

- The requirement is rather broad so I time boxed this exercise and picked EC2 and RDS in AWS for simplicity. 
  - EC2, no particular reason, it's a popular choice for a wide range of features including scalability, instance types and price performance. Ultimately, the choice of cloud service is largely based on the system needs. 
  - RDS, no particular reason either, it can be relational or non relational, again, it's based on the system design and needs.
- The EC2 instances are exposed to the public and can be accessed anywhere on the internet, hence it's on a public subnet
- The EC2 instances are given the option to SSH into from a specified IP address/range to test and troubleshoot
- The database can only be accessed by the EC2 instances and is protected on a private subnet 
- Security groups are created for ingress/egress rules
- Due to time constraint, I used local backend instead of a remote backend.

- An open source simple server `echo-server` is containerized using Docker and deployed on the EC2 instance, this is optional
- All resources were provisioned successfully and destroyed to avoid charges.

- The files in the `terraform/` directory can potentially be moved into a `modules/` sub-directory and have new files calling the module to provision for multiple environments.
- The structure of the `terraform/` directory breaks the infrastructure code into cleaner and more readable blocks, I normally use the following structure:
  - Core
    - required providers and versions, e.g. aws, google 
    - core global infrastructure, e.g. artifact registry, DNS, storage buckets
    - core application infrastructure, e.g. compute engine, database, k8s cluster
  - Dependencies
    - vpc and network related dependencies
    - routes and route tables
    - security groups
    - IAM
    - variables 
    - env vars file
    - outputs

- Choice of VPC CIDR blocks
  - small network for the exercise, 256 IP addresses that can further break into private and public subnets
  - recommended range in RFC 1918
  - distinguish private and public subnets with `(4th byte < 128)` for public and `(4th byte > 127)` for private

## Usage
Set up submodule, run 
```bash
git submodule init
git submodule update
```
Build and push Docker image to AWS registry (ECR needs to be provisioned first), run
```bash
# Setup your AWS Cli and authenticate to ECR 
aws configure # follow the prompts
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ECR_URI>
./scripts/build-push-image.sh
```
Provision infrastructure for core infrastructure, run
```bash
# initiate the plugins and modules
terraform -chdir=terraform/ init
# plan to see the resources being created, updated or destroyed
terraform -chdir=terraform/ plan -var-file=env.tfvars
# apply to provision the resources
terraform -chdir=terraform/ apply -var-file=env.tfvars -auto-approve
# destroy after the exercise to avoid incurred cost on unused resources
terraform -chdir=terraform/ destroy -var-file=env.tfvars
```
## Verification
- SSH into the EC2 instance
- Install the mysql-client 
- Connect the database using the db address and port from the terraform output 
  ```bash
  mysql -h <database-endpoint> -P <database-port> -u <db-username> -p
  ```
- Enter the db password
- You should see the db name in the database list when run `show DATABASES`
