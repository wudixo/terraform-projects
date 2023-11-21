provider "aws" {
  region     = "eu-west-2"
}


resource "tls_private_key" "wudixo" {
 algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
 key_name = "999"
 public_key = "${tls_private_key.999.public_key_openssh}"
 depends_on = [
  tls_private_key.999
 ]
}

resource "local_file" "key" {
 content = "${tls_private_key.999.private_key_pem}"
 filename = "999.pem"
 file_permission ="0400"
 depends_on = [
  tls_private_key.999
 ]
}

resource "aws_vpc" "wudixovpc" {
 cidr_block = "10.0.0.0/16"
 instance_tenancy = "default"
 enable_dns_hostnames = "true" 
 tags = {
  Name = "wudixovpc"
 }
}

resource "aws_security_group" "wudixosg" {
 name = "wudixosg"
 description = "This firewall allows SSH, HTTP and MYSQL"
 vpc_id = "${aws_vpc.wudixovpc.id}"
 
 ingress {
  description = "SSH"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress { 
  description = "HTTP"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress {
  description = "TCP"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 tags = {
  Name = "wudixosg"
 }
}

resource "aws_subnet" "public" {
 vpc_id = "${aws_vpc.wudixovpc.id}"
 cidr_block = "10.0.0.0/24"
 availability_zone = "eu-west-2a"
 map_public_ip_on_launch = "true"
 
 tags = {
  Name = "my_public_subnet"
 } 
}
resource "aws_subnet" "private" {
 vpc_id = "${aws_vpc.wudixovpc.id}"
 cidr_block = "10.0.1.0/24"
 availability_zone = "eu-west-2b"
 
 tags = {
  Name = "my_private_subnet"
 }
}

resource "aws_internet_gateway" "wudixoigw" {
 vpc_id = "${aws_vpc.wudixovpc.id}"
 
 tags = { 
  Name = "wudixoigw"
 }
}

resource "aws_route_table" "wudixort" {
 vpc_id = "${aws_vpc.wudixovpc.id}"
 
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.wudixoigw.id}"
 }
 
 tags = {
  Name = "wudixort"
 }
}

resource "aws_route_table_association" "a" {
 subnet_id = "${aws_subnet.public.id}"
 route_table_id = "${aws_route_table.wudixort.id}"
}

resource "aws_route_table_association" "b" {
 subnet_id = "${aws_subnet.private.id}"
 route_table_id = "${aws_route_table.wudixort.id}"
}

resource "aws_instance" "myserver" {
 ami = "ami-02a2af70a66af6dfb"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.generated_key.key_name}"
 vpc_security_group_ids = [ "${aws_security_group.wudixosg.id}" ]
 subnet_id = "${aws_subnet.public.id}"
 
 tags = {
  Name = "myserver"
 }
}
