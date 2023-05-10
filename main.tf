resource "aws_vpc" "jenkins-vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jenkins-vpc.id
  tags = {
    Name = var.igw_name
  }
}
resource "aws_subnet" "public_subnet_jenkins" {
  vpc_id     = aws_vpc.jenkins-vpc.id
  cidr_block = var.public_cidr_block
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.jenkins-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "jenkins-public-route-table"
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_jenkins.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_security_group" "jenkins-security-group" {
  name = "jenkins-security-group"
  vpc_id = aws_vpc.jenkins-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"] # Canonical
# }
resource "aws_key_pair" "Project-key" {
  key_name   = "new-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_instance" "jenkins" {
  #ami   = data.aws_ami.ubuntu.id
  ami = var.ami_id
  instance_type = "t2.xlarge"
  subnet_id     = aws_subnet.public_subnet_jenkins.id
  availability_zone = var.az1
  key_name = aws_key_pair.Project-key.key_name
  user_data = file("jenkins.sh")
  vpc_security_group_ids = [aws_security_group.jenkins-security-group.id]
}