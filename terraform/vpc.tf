# Internet VPC
resource "aws_vpc" "application" {
    cidr_block = "172.32.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "application"
        Owner = "Ankur"
    }
}


# Subnets
resource "aws_subnet" "application-public-a1-sb" {
    vpc_id = "${aws_vpc.application.id}"
    cidr_block = "172.32.0.0/20"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags {
        Name = "application-public-a1-sb"
        Owner = "Ankur"
    }
}
resource "aws_subnet" "application-public-b1-sb" {
    vpc_id = "${aws_vpc.application.id}"
    cidr_block = "172.32.16.0/20"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"

    tags {
        Name = "application-public-b1-sb"
        Owner = "Ankur"
    }
}

resource "aws_subnet" "application-private-a1-sb" {
    vpc_id = "${aws_vpc.application.id}"
    cidr_block = "172.32.48.0/20"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"

    tags {
        Name = "application-private-a1-sb"
        Owner = "Ankur"
    }
}
resource "aws_subnet" "application-private-b1-sb" {
    vpc_id = "${aws_vpc.application.id}"
    cidr_block = "172.32.64.0/20"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"

    tags {
        Name = "application-private-b1-sb"
        Owner = "Ankur"
    }
}

# Internet GW
resource "aws_internet_gateway" "application-gw" {
    vpc_id = "${aws_vpc.application.id}"

    tags {
        Name = "application-gw"
        Owner = "Ankur"
    }
}

# route tables
resource "aws_route_table" "application-public-rt" {
    vpc_id = "${aws_vpc.application.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.application-gw.id}"
    }

    tags {
        Name = "application-public-rt"
        Owner = "Ankur"
    }
}

# route associations public
resource "aws_route_table_association" "application-public-1-rta" {
    subnet_id = "${aws_subnet.application-public-a1-sb.id}"
    route_table_id = "${aws_route_table.application-public-rt.id}"
}
resource "aws_route_table_association" "application-public-2-rta" {
    subnet_id = "${aws_subnet.application-public-b1-sb.id}"
    route_table_id = "${aws_route_table.application-public-rt.id}"
}
