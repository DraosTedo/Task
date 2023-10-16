# Dockerize MySQL/Mongo/PHP App. 

Overview
This project demonstrates the creation of a highly available, multi-container infrastructure using Terraform. It includes the provisioning of an Amazon Web Services (AWS) Virtual Private Cloud (VPC) along with essential resources, and the orchestration of three containers using Docker Compose. The result is a web application that reads data from two databases (MySQL and MongoDB) using a PHP script.

Terraform Infrastructure
Provider
Provider: AWS
Region: eu-central-1 (Frankfurt, Germany)

Resources
VPC (Virtual Private Cloud)
CIDR Block: 10.0.0.0/16

Internet Gateway
Associates with the VPC for public internet access.

Subnet
CIDR Block: 10.0.1.0/24
Associates with the VPC.

Security Group
Name: example
Description: Allowing Access
Allows incoming and outgoing traffic for various ports including 22 (SSH), 3306 (MySQL), 27017 (MongoDB), 8080 (Web App), 80 (HTTP).
Egress (Outgoing) traffic is allowed to all destinations.

Route Table
Creates a default route table associated with the VPC and directs traffic to the Internet Gateway.

Main Route Table Association
Associates the main route table with the VPC.

Launch Configuration
Name: example
Amazon Machine Image (AMI): ami-0427a796a4e582276 (Amazon Linux 2)
Instance Type: t2.medium
Associates a public IP address.
Installs Docker, Apache (httpd), and Docker Compose.
Creates directories for the MongoDB, MySQL, and PHP App.

Autoscaling Group
Desired Capacity: 2
Maximum Capacity: 5
Minimum Capacity: 1
Health Check Type: ELB (Elastic Load Balancer)
Uses the launch configuration and assigns it to a subnet.
Ensures high availability with multiple instances.

Elastic Load Balancer (ELB)
Name: example
Listens on ports 80 (HTTP) and 8080 (Web App).
Conducts health checks.

Docker Containers
1. Web Frontend
Image: PHP 7.0.33 with Xdebug and Apache
Configured to run a PHP web application.
Exposes port 80 (HTTP).

2. MySQL
Image: MySQL 5.7
Runs a MySQL database.
Exposes port 3306.

3. MongoDB
Image: MongoDB 4.2
Runs a MongoDB database.
Exposes port 27017.

End Result
After provisioning the infrastructure using Terraform and configuring the containers, you'll have a highly available web application. The PHP script within the web container retrieves dummy data from both the MySQL and MongoDB databases. Access the application through the ELB's URL on ports 80 and 8080 to see the PHP script fetching data from both databases.

How to Use
Clone this repository.
Make sure you have Terraform installed and configured with AWS credentials.
In the root directory, run terraform init and then terraform apply to create the AWS infrastructure.
After the Terraform infrastructure is ready, navigate to the app/ directory.
Run docker-compose up --build to create and start the Docker containers.
Access the application through the ELB's URL on ports 80 and 8080 to see the PHP script fetching data from both databases.
Enjoy your highly available multi-container web application with MySQL and MongoDB databases! 
