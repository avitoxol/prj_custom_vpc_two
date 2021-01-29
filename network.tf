resource "aws_vpc" "testvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
      Name = "testvpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.testvpc.id

    tags = {
      Name = "igw"
    }
}

resource "aws_eip" "my-nat-eip" {
  vpc = true

  tags = {
    Name = "NATGWIP"
  }
}

resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.my-nat-eip.id
  subnet_id     = aws_subnet.primary.id
}

resource "aws_route_table" "priv_one" {
  vpc_id = aws_vpc.testvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_natgw.id
  }
}


resource "aws_route_table" "pub_route_table" {
    vpc_id = aws_vpc.testvpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "Public_Route"
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "primary" {
    vpc_id = aws_vpc.testvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "secondary" {
    vpc_id = aws_vpc.testvpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "prv_one" {
    vpc_id = aws_vpc.testvpc.id
    cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "prv_two" {
    vpc_id = aws_vpc.testvpc.id
    cidr_block = "10.0.4.0/24"
}


resource "aws_route_table_association" "pub_one" {
    route_table_id = aws_route_table.pub_route_table.id
    subnet_id = aws_subnet.primary.id
}

resource "aws_route_table_association" "priv_one" {
    route_table_id = aws_route_table.priv_one.id
    subnet_id = aws_subnet.prv_one.id
}
