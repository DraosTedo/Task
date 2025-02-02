resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.subnet_cidr
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_main_route_table_association" "example" {
  vpc_id         = aws_vpc.example.id
  route_table_id = aws_route_table.example.id
}
