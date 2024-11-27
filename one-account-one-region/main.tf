# Provider
provider "aws" {
  region = "eu-west-1" # Set to the eu-west-1 region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "subnet-c"
  }
}

# Network Interfaces
resource "aws_network_interface" "interface_a" {
  subnet_id = aws_subnet.subnet_a.id
  tags = {
    Name = "network-interface-a"
  }
}

resource "aws_network_interface" "interface_b" {
  subnet_id = aws_subnet.subnet_b.id
  tags = {
    Name = "network-interface-b"
  }
}

resource "aws_network_interface" "interface_c" {
  subnet_id = aws_subnet.subnet_c.id
  tags = {
    Name = "network-interface-c"
  }
}
