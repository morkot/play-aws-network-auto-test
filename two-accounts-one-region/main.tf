# provider "aws" {
#   alias  = "eu-west-1"
#   region = "eu-west-1"
# }

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-1-member"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::314146335982:role/OrganizationAccountAccessRole"
  }
}

# VPC in us-east-1
resource "aws_vpc" "vpc_us_east" {
  provider             = aws.us-east-1
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-US-East-1"
  }
}

# VPC in us-east-1-member account
resource "aws_vpc" "vpc_us_east_member" {
  provider             = aws.us-east-1-member
  cidr_block           = "10.2.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-US-East-1-Member"
  }
}

# # Transit Gateway in eu-west-1
# resource "aws_ec2_transit_gateway" "tgw_eu_west" {
#   provider        = aws.eu-west-1
#   description     = "Transit Gateway in EU West"
#   amazon_side_asn = 64512
#   tags = {
#     Name = "TGW-EU-West-1"
#   }
# }

# # Transit Gateway in us-east-1
# resource "aws_ec2_transit_gateway" "tgw_us_east" {
#   provider        = aws.us-east-1
#   description     = "Transit Gateway in US East"
#   amazon_side_asn = 64512
#   tags = {
#     Name = "TGW-US-East-1"
#   }
# }

# # Attach VPC to Transit Gateway in eu-west-1
# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_eu_west" {
#   provider           = aws.eu-west-1
#   transit_gateway_id = aws_ec2_transit_gateway.tgw_eu_west.id
#   vpc_id             = aws_vpc.vpc_eu_west.id
#   subnet_ids         = [aws_subnet.subnet_eu_west.id]
# }

# # Attach VPC to Transit Gateway in us-east-1
# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_us_east" {
#   provider           = aws.us-east-1
#   transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
#   vpc_id             = aws_vpc.vpc_us_east.id
#   subnet_ids         = [aws_subnet.subnet_us_east.id]
# }

# # Transit Gateway Peering Connection
# resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
#   provider                = aws.eu-west-1
#   peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east.id
#   transit_gateway_id      = aws_ec2_transit_gateway.tgw_eu_west.id
#   peer_region             = "us-east-1"
#   tags = {
#     Name = "TGW-Peering-EU-US"
#   }
# }

# Create subnets for VPC in us-east-1-member
resource "aws_subnet" "subnet_us_east_member" {
  provider          = aws.us-east-1-member
  vpc_id            = aws_vpc.vpc_us_east_member.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-us-east-1-member"
  }
}

# Create subnets for VPC in us-east-1
resource "aws_subnet" "subnet_us_east" {
  provider          = aws.us-east-1
  vpc_id            = aws_vpc.vpc_us_east.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-US-East-1"
  }
}

# Network Interface in us-east-1-member
resource "aws_network_interface" "eni_us_east_member" {
  provider        = aws.us-east-1-member
  subnet_id       = aws_subnet.subnet_us_east_member.id
  private_ips     = ["10.2.1.10"]
  security_groups = [aws_security_group.sg_us_east_member.id]
  tags = {
    Name = "ENI-us-east-1-member"
  }
}

# Network Interface in us-east-1
resource "aws_network_interface" "eni_us_east" {
  provider        = aws.us-east-1
  subnet_id       = aws_subnet.subnet_us_east.id
  private_ips     = ["10.1.1.10"]
  security_groups = [aws_security_group.sg_us_east.id]
  tags = {
    Name = "ENI-US-East"
  }
}

# Security Group for Network Interface in us-east-1-member
resource "aws_security_group" "sg_us_east_member" {
  provider    = aws.us-east-1-member
  vpc_id      = aws_vpc.vpc_us_east_member.id
  name        = "SG-us_east_member"
  description = "Security Group for ENI in us_east_member"
}

# Security Group for Network Interface in US East
resource "aws_security_group" "sg_us_east" {
  provider    = aws.us-east-1
  vpc_id      = aws_vpc.vpc_us_east.id
  name        = "SG-US-East"
  description = "Security Group for ENI in US East"
}
