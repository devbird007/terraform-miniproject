resource "aws_vpc" "Altschool_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    
    tags = {
        Name = "Altschool_vpc"
    }
}

resource "aws_subnet" "public_subnets" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.Altschool_vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = lookup(each.value, "availability_zone", null)
    map_public_ip_on_launch = true

    tags = {
        Name = each.key
    }
}

resource "aws_subnet" "private_subnets" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.Altschool_vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = lookup(each.value, "availability_zone", null)

    tags = {
        Name = each.key
    }  
}

resource "aws_internet_gateway" "altschool-internet-gateway" {
    vpc_id = aws_vpc.Altschool_vpc.id

    tags = {
        Name = "altschool-terraform-internet-gateway"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.Altschool_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.altschool-internet-gateway.id
    }

    tags = {
      Name = "terraform-public-route-table"
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.Altschool_vpc.id

    tags = {
        Name = "terraform-private-route-table"
    }
}

resource "aws_route_table_association" "route-table-association" {
    for_each = var.public_subnets
    subnet_id = aws_subnet.public_subnets[each.key].id
    route_table_id = aws_route_table.public-rt.id
}

# resource "aws_route_table_association" "route-table-association" {
#     for_each = var.private_subnets
#     subnet_id = aws_subnet.private_subnets[each.key].id
#     route_table_id = aws_route_table.private-rt.id
# }