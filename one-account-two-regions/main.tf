provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

module "vpc_us_east_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  providers = {
    aws = aws.us_east_1
  }

  name                 = "vpc-us-east-1"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_dns_hostnames = false
  enable_dns_support   = false
}

module "vpc_eu_west_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  providers = {
    aws = aws.eu_west_1
  }

  name                 = "vpc-eu-west-1"
  cidr                 = "10.1.0.0/16"
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets      = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets       = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  enable_dns_hostnames = false
  enable_dns_support   = false
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  provider    = aws.us_east_1
  vpc_id      = module.vpc_us_east_1.vpc_id
  peer_vpc_id = module.vpc_eu_west_1.vpc_id
  peer_region = "eu-west-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  provider                  = aws.eu_west_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
}

resource "aws_route" "route_to_eu_west_1" {
  provider                  = aws.us_east_1
  route_table_id            = module.vpc_us_east_1.private_route_table_ids[0]
  destination_cidr_block    = module.vpc_eu_west_1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_to_us_east_1" {
  provider                  = aws.eu_west_1
  route_table_id            = module.vpc_eu_west_1.private_route_table_ids[0]
  destination_cidr_block    = module.vpc_us_east_1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# output "vpc_us_east_1_id" {
#   value = module.vpc_us_east_1.vpc_id
# }

# output "vpc_eu_west_1_id" {
#   value = module.vpc_eu_west_1.vpc_id
# }

# output "vpc_peering_connection_id" {
#   value = aws_vpc_peering_connection.vpc_peering.id
# }
