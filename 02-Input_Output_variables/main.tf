resource "aws_instance" "ec2_vm" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  security_groups = ["OG"]
  tags = {
   Name = "EC2-VM"
  }
}
