provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Allowing Access"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_launch_configuration" "example" {
  name          = "example"
  image_id      = "ami-0427a796a4e582276"
  instance_type = "t2.medium"

  associate_public_ip_address = true

  security_groups = [aws_security_group.example.id]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
#!/bin/bash

# Install Docker
sudo yum update -y
sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Apache (httpd)
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify The Installation
docker-compose version

# Create directories for MongoDB, MySQL, and PHP App
mkdir /home/ec2-user/php
mkdir /home/ec2-user/mysql
mkdir /home/ec2-user/mongodb
EOF

}

resource "aws_autoscaling_group" "example" {
  desired_capacity  = 2
  max_size          = 5
  min_size          = 1
  health_check_type = "ELB"

  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = [aws_subnet.example.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "example" {
  name            = "example"
  subnets         = [aws_subnet.example.id]
  security_groups = [aws_security_group.example.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

