variable "region" {
  description = "Default region name"
  type        = string
  default     = "ap-south-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

# Fetching our Default VPC
data "aws_vpc" "name" {
  tags = {
    Name = "Default"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "Myserver" {
  ami                         = "ami-0fd05997b4dff7aac"
  instance_type               = "t2.micro"
  user_data                   = filebase64("./EC2.sh")
  vpc_security_group_ids      = [aws_security_group.EC2-SG.id]
  associate_public_ip_address = true
}

# Creating SG for EC2
resource "aws_security_group" "EC2-SG" {
  name        = "EC2-SG"
  description = "Allow HTTP inbound traffic for EC2 from ALB"
  vpc_id      = data.aws_vpc.name.id
  tags = {
    Name      = "EC2-SG"
    Terraform = true
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
#   security_group_id = aws_security_group.EC2-SG.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "icmp"
#   from_port         = -1
#   to_port           = -1
# }

# # Creating SSH ingress rule for SG of EC2
# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_for_EC2" {
#   security_group_id = aws_security_group.EC2-SG.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# # Creating SSH ingress rule for SG of EC2
# resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_for_EC2-Internet" {
#   security_group_id = aws_security_group.EC2-SG.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }


