resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags {
      Name = "dev_vpc"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.dev.id}"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.pub_sub_cidr)}"

  vpc_id                  = "${aws_vpc.dev.id}"
  cidr_block              = "${var.pub_sub_cidr[count.index]}"
  availability_zone       = "${var.az_list[count.index]}"
  map_public_ip_on_launch = "true"
  tags {
      Name = "pub_sub-${count.index+1}"
  }
}
resource "aws_route_table" "pub_route" {
    vpc_id = "${aws_vpc.dev.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags {
      Name = "pub_route"
  }
}
resource "aws_route_table_association" "public_subnets" {
  count          = "${length(var.pub_sub_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.pub_route.id}"
}
