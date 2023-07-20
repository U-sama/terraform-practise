provider "aws" {
    region = "eu-west-3"
    # we can use the access key and secret key from environment variables provided by [aws configure] command
    access_key = "AAAAAAAAAAAA"
    secret_key = "BBBBBBBBBBBB"
  
}

variable "cidr_blocks" {
  description = "cidr blooks and name tags for vpcs and subnets"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

variable "subnet_cidr_block" {
    description = "Subnet cidr block"
    default = "10.0.40.0/24"
    type = string
}

variable "vpc_cidr_block" {
    description = "VPC cidr block" 
  
}

variable "environment" {
  description = "deployment environment"
}

resource "aws_vpc" "development" {
    # cidr_block = var.vpc_cidr_block
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
    #   Name = var.environment
      Name = var.cidr_blocks[0].name
      vpc_env = "dev"
    }
  
}

resource "aws_subnet" "new-subnet" {
    vpc_id = aws_vpc.development.id
    # cidr_block = var.subnet_cidr_block
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "eu-west-3a"
    tags = {
    #   Name = "subnet-dev-1"
        Name = var.cidr_blocks[1].name
    }
  
}

data "aws_vpc" "existing-vpc" {
    default = true
}

resource "aws_subnet" "new-default-subnet" {
    vpc_id = data.aws_vpc.existing-vpc.id
    cidr_block = "172.60.48.0/20"
    availability_zone = "eu-west-3a"
    tags = {
      Name = "subnet-default-2"
    }
  
}

output "development-out" {
    value = aws_vpc.development.id
}

output "subnet-dev" {
    value = aws_subnet.new-default-subnet.id
}