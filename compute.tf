resource "aws_launch_configuration" "example" {
  name          = "example"
  image_id = var.ami_id
  instance_type = var.instance_type

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
  desired_capacity  = var.desired_capacity
  max_size          = var.max_size
  min_size          = var.min_size
  health_check_type = "ELB"

  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = [aws_subnet.example.id]

  lifecycle {
    create_before_destroy = true
  }
}
