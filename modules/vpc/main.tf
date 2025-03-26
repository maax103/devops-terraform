resource "aws_vpc" "max-vpc" {
  cidr_block = "172.112.0.0/16"

  tags = {
    Name = "max-vpc"
  } 
}

resource "aws_subnet" "subnet_pub_c" {
    vpc_id = aws_vpc.max-vpc.id
    cidr_block = cidrsubnet(aws_vpc.max-vpc.cidr_block, 8, 3)
    availability_zone = "${var.project_region}c"
    map_public_ip_on_launch = true
    tags = {
        Unity = "${var.project_name}-vpc"
        Name = "${var.project_name}-subnet_pub_c"
    }
}

resource "aws_subnet" "subnet_pub_b" {
    vpc_id = aws_vpc.max-vpc.id
    cidr_block = cidrsubnet(aws_vpc.max-vpc.cidr_block, 8, 4)
    availability_zone = "${var.project_region}b"
    map_public_ip_on_launch = true
    tags = {
        Unity = "${var.project_name}-vpc"
        Name = "${var.project_name}-subnet_pub_b"
    }
}

resource "aws_subnet" "subnet_priv_c" {
  vpc_id = aws_vpc.max-vpc.id
  cidr_block = cidrsubnet(aws_vpc.max-vpc.cidr_block, 8, 5)
  availability_zone = "${var.project_region}c"
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}-subnet_priv_c"
  }
}

resource "aws_subnet" "subnet_priv_b" {
  vpc_id = aws_vpc.max-vpc.id
  cidr_block = cidrsubnet(aws_vpc.max-vpc.cidr_block, 8, 6)
  availability_zone = "${var.project_region}b"
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}_subnet_priv_b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.max-vpc.id
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}_igw" 
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.max-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id    
  }
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}_route_pub"
  }
}

resource "aws_route_table_association" "route_pub_b" {
  subnet_id = aws_subnet.subnet_pub_b.id
  route_table_id = aws_route_table.route_public.id  
}

resource "aws_nat_gateway" "gw_nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.subnet_pub_b.id
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}_gw_nat"
  }
}