# ================== Create VPC ==================

resource "aws_vpc" "TF_VPC_proj_4" {
  cidr_block       = "10.80.0.0/22"
  tags = {
    Name  = "vpc_proj_4"
    owner = "ninja"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.TF_VPC_proj_4.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name  = "TF_proj_4_Public_Subnet_${count.index + 1}"
    owner = "ninja"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.TF_VPC_proj_4.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name  = "TF_proj_4_Private_Subnet_${count.index + 1}"
    owner = "ninja"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.TF_VPC_proj_4.id
  tags = {
    Name  = "TF_VPC_proj_4_IGW"
    owner = "ninja"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.TF_VPC_proj_4.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name  = "TF_VPC_proj_4_Public_RT"
    owner = "ninja"
  }
}

resource "aws_route_table_association" "public_subnet_2_rt" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

