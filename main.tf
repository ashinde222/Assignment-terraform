
# creating vpc
resource "aws_vpc" "myvpc" {

	cidr_block = "10.10.0.0/16"
	tags = {
		Name = "myvpc"
	}
}

#creating subnets
resource "aws_subnet" "subneta" {

	cidr_block = "10.10.1.0/24"
	vpc_id = "${aws_vpc.myvpc.id}"
	availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "subnetb" {

	vpc_id = "${aws_vpc.myvpc.id}"
	cidr_block = "10.10.2.0/24"
	availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}

#creating IGW
resource "aws_internet_gateway" "igw" {

	vpc_id = "${aws_vpc.myvpc.id}"
}

#creating route tables
resource "aws_route_table" "rttest" {
	
	vpc_id = "${aws_vpc.myvpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}
}
#route table associations
resource "aws_route_table_association" "rta1" {

	subnet_id = "${aws_subnet.subneta.id}"	
	route_table_id = "${aws_route_table.rttest.id}"
}
resource "aws_route_table_association" "rtb2" {

	subnet_id = "${aws_subnet.subnetb.id}"
	route_table_id = "${aws_route_table.rttest.id}"
}

#creating security group for new vpc

resource "aws_security_group" "sg" {

   name = "sg"
   vpc_id = "${aws_vpc.myvpc.id}"

   ingress {
            from_port = 80
            to_port   = 80
            protocol  = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
            from_port = 0
            to_port   = 0
            protocol  = "-1"
            cidr_blocks = ["0.0.0.0/0"]

    }

}

#creating  ec2 instance
resource "aws_instance" "httpd" {

	ami = "ami-0e12ffc2dd465f6e4"
	instance_type = "t3.micro"
  key_name  = "Linuxpem"
  subnet_id = aws_subnet.subneta.id
  associate_public_ip_address = true
	vpc_security_group_ids = ["${aws_security_group.sg.id}"]
	user_data =	<<-EOF
			#!/bin/bash
			dnf update -y
			dnf install -y httpd
			
			systemctl start httpd
			systemctl enable httpd
	echo "<h1>Welcome Ajay! Terraform HTTPD Server is Working </h1>" > /var/www/html/index.html 
	EOF
	tags = {
		Name = "httpd_server"
	}
}



