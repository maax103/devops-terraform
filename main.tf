terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.project_region
}

module "vpc" {
  source = "./modules/vpc"
  project_region = var.project_region
  project_name = var.project_name
}

module "ec2" {
  source = "./modules/ec2"
  nginx_pub_subnet_id = module.vpc.pub_subnet_b_id
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
}

# resource "aws_instance" "app_server" {
#   ami = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     "Name" = "mainEc2"
#   }
# }
