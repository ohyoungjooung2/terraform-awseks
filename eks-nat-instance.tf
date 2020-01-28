# eks-nat-instance.tf
# Terraform file for creating a NAT instance with custom nat rules

#Aws key generate
resource "aws_key_pair" "eks-nat" {
  key_name   = "eks-nat"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4npOxRLwVg8xxjRBY6sZoBakJdBCMQl5QWH/nREzYTTumVWh6NinAAe9Hi5wKZ4OTFqM9cuS67DoHo9wfHK/oGvxcY+DfG4Wa9YjQ6b+5D1bnjPHH5JGlDt5mBhqXYR4tc3y2BrutBRVZ+MYFi7bhIFDaoOOXVeDLdz5kOUGsMUKIe0gn0rUnSCZTzj4een2Zg/88Xam0c7ft5vXORFOZvuXNezY8nUr1lc8pU2LStE5em5o2SlEw8voZL7mIyS+6mk/rFrHWuncvo+O61D+MUDEYfgn75K9IbMsHxqGt9TKB1+xaW3MhGF0xQeQnuEWRVQig77xcbvhiuxWByzkZ oyj@controller"

}


resource "aws_instance" "nat" {
	ami = "${lookup(var.aws_nat_ami, var.aws_region)}"
	instance_type = "t2.micro"
	key_name = "eks-nat"
	vpc_security_group_ids = ["${aws_security_group.nat.id}"]
	subnet_id = "${aws_subnet.eks-node-subnet-pub1.id}"
	associate_public_ip_address = true
	source_dest_check = false
	#user_data = "${file("nat-user-data.yml")}"
	tags = {
		Name = "nat"
	}
}

#resource "aws_eip" "nat" {
#	instance = "${aws_instance.nat.id}"
#	vpc = true
#}

resource "aws_security_group" "nat" {
	name = "nat"
	description = "Allow services from the private subnet through NAT"
	vpc_id = "${aws_vpc.eks-vpc.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		security_groups = ["${aws_security_group.private.id}"]
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "udp"
		security_groups = ["${aws_security_group.private.id}"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags =  {
		Name = "nat sg"
	}
}
