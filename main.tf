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
  nginx_pub_subnet_id_b = module.vpc.pub_subnet_b_id
  nginx_pub_subnet_id_c = module.vpc.pub_subnet_c_id
  priv_subnet_id_b = module.vpc.priv_subnet_b_id
  priv_subnet_id_c = module.vpc.priv_subnet_c_id
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
}
