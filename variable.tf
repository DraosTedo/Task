variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "ami_id" {
  description = "AMI id for ec2 instance"
  type = string
  default = "ami-0427a796a4e582276"
}

variable "instance_type" {
  description = "EC2 Instance type "
  type = string
  default = "t2.medium"
}

variable "desired_capacity" {
  description = "Number of instances in the ASG"
  type = number
  default = 2
}

variable "max_size" {
  description = "Maximum Number of instances in the ASG"
  type = number
  default = 5
}

variable "min_size" {
  description = "Minimum number of instance in the ASG"
  type = number
  default = 1
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.1.0/24"
}

variable "subnet_cidr" {
  description = "CIDR block for the Subnets"
  type = string
  default = "10.0.1.0/24"
}

variable "allowed_ports" {
  description = "List of allowed ingress ports"
  type = list(number)
  default = [ 22, 80, 8080, 3306, 27017 ]
}                                                                                                                                                                                           
