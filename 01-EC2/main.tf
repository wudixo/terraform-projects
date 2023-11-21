resource "aws_instance" "linux-vm"{	
	ami = "ami-02e94b011299ef128"
	instance_type = "t2.micro"
	key_name = "999"
	security_groups = ["OG"]
	tags = {
		Name = "WUDI-VM"
	}
}
