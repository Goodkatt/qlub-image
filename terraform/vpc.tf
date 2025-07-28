module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "qlub-vpc"
  cidr = "172.59.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["172.59.0.0/24", "172.59.1.0/24", "172.59.2.0/24"]
  public_subnets  = ["172.59.4.0/24", "172.59.5.0/24", "172.59.6.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    Project = "Qlub"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
}