#VPC
resource "aws_vpc" "shopease_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ShopEase-VPC"
  }  
}

#Internet Gateway

resource "aws_internet_gateway" "shopease_igw" {
  vpc_id = aws_vpc.shopease_vpc.id

  tags = {
    Name = "ShopEase-IGW"
  }
}

#Subnets
#public_subnet_1
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.shopease_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1"
  }
}
#public_subnet_2
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.shopease_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-2"
  }
}
#private_subnet_1
resource "aws_subnet" "private_app_subnet_1" {

  vpc_id = aws_vpc.shopease_vpc.id

  cidr_block = "10.0.11.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "Private-App-Subnet-1"
  }
}

#private_subnet_2
resource "aws_subnet" "private_app_subnet_2" {

  vpc_id = aws_vpc.shopease_vpc.id

  cidr_block = "10.0.12.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "Private-App-Subnet-2"
  }
}

#Db_subnet_1
resource "aws_subnet" "private_db_subnet_1" {

  vpc_id = aws_vpc.shopease_vpc.id

  cidr_block = "10.0.21.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "Private-DB-Subnet-1"
  }
}

#Db_subnet_2
resource "aws_subnet" "private_db_subnet_2" {

  vpc_id = aws_vpc.shopease_vpc.id

  cidr_block = "10.0.22.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "Private-DB-Subnet-2"
  }
}

#Route Table
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.shopease_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.shopease_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

#Route Table Association

resource "aws_route_table_association" "public_subnet_1_assoc" {

  subnet_id = aws_subnet.public_subnet_1.id

  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {

  subnet_id = aws_subnet.public_subnet_2.id

  route_table_id = aws_route_table.public_rt.id
}

#Eip  
resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "ShopEase-NAT-EIP"
  }
}

#Nat Gateway

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "ShopEase-NAT"
  }

  depends_on = [
    aws_internet_gateway.shopease_igw
  ]
}

#Private Route Table

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.shopease_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

#Private Route Table Association
resource "aws_route_table_association" "private_app_subnet_1_assoc" {

  subnet_id = aws_subnet.private_app_subnet_1.id

  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_subnet_2_assoc" {

  subnet_id = aws_subnet.private_app_subnet_2.id

  route_table_id = aws_route_table.private_rt.id
}

#Database Route Table
resource "aws_route_table" "db_rt" {

  vpc_id = aws_vpc.shopease_vpc.id

  tags = {
    Name = "DB-Route-Table"
  }
}

resource "aws_route_table_association" "db_subnet_1_assoc" {

  subnet_id = aws_subnet.private_db_subnet_1.id

  route_table_id = aws_route_table.db_rt.id
}

resource "aws_route_table_association" "db_subnet_2_assoc" {

  subnet_id = aws_subnet.private_db_subnet_2.id

  route_table_id = aws_route_table.db_rt.id
}
