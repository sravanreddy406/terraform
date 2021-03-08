provider "aws" {
    region = "us-east-1"
}

variable vpc_cidr_block {}
variable public_subnet_cidr_block {}
variable private_subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}
 
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.public_subnet_cidr_block
    tags = {
        Name: "${var.env_prefix}-public-subnet-1"
    }
}

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.private_subnet_cidr_block
    tags = {
        Name: "${var.env_prefix}-private-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
  }
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb" 
    }
}


resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080 
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
        Name: "${var.env_prefix}-sg"
    }
}
