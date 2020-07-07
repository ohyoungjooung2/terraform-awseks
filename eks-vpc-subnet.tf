resource "aws_vpc" "eks-vpc" {
      cidr_block = "10.0.0.0/16"
      tags = "${
        map(
        "Name", "terraform-eks-node",
        "kubernetes.io/cluster/{var.cluster-name}", "shared",
        )
      }"
}

#data "aws_availability_zones" "available" {}

resource "aws_subnet" "eks-node-subnet-pub1" {
      availability_zone = "ap-northeast-2a"
      cidr_block = "10.0.0.0/24"
      vpc_id = "${aws_vpc.eks-vpc.id}"
      map_public_ip_on_launch = "true"
      tags = "${
         map(
         "Name","terraform-eks-node-subnet-pub",
         "kubernetes.io/cluster/${var.cluster-name}","shared",
         )
      }"
}
resource "aws_subnet" "eks-node-subnet-pub2" {
      availability_zone = "ap-northeast-2b"
      cidr_block = "10.0.1.0/24"
      vpc_id = "${aws_vpc.eks-vpc.id}"
      map_public_ip_on_launch = "true"
      tags = "${
         map(
         "Name","terraform-eks-node-subnet-pub",
         "kubernetes.io/cluster/${var.cluster-name}","shared",
         )
      }"
}
#priv subnet
resource "aws_subnet" "eks-node-subnet-pri1" {
      availability_zone = "ap-northeast-2a"
      cidr_block = "10.0.2.0/24"
      vpc_id = "${aws_vpc.eks-vpc.id}"
      tags = "${
         map(
         "Name","terraform-eks-node-subnet-pri1",
         "kubernetes.io/role/internal-elb","1",
         "kubernetes.io/cluster/${var.cluster-name}","shared",
         )
      }"
}

#priv subnet2
resource "aws_subnet" "eks-node-subnet-pri2" {
      availability_zone = "ap-northeast-2c"
      cidr_block = "10.0.3.0/24"
      vpc_id = "${aws_vpc.eks-vpc.id}"
      tags = "${
         map(
         "Name","terraform-eks-node-subnet-pri1",
         "kubernetes.io/cluster/${var.cluster-name}","shared",
         "kubernetes.io/role/internal-elb","1",
         )
      }"
}

resource "aws_internet_gateway" "eks-gw" {
      vpc_id = "${aws_vpc.eks-vpc.id}"
      tags =  {
          Name = "terraform-eks-gw"
      }
}

resource "aws_route_table" "eks-rt" {
      vpc_id = "${aws_vpc.eks-vpc.id}"
      route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.eks-gw.id}"
      }
}
      

resource "aws_route_table_association" "eks-rt-association1" {
      subnet_id = "${aws_subnet.eks-node-subnet-pub1.id}"
      route_table_id = "${aws_route_table.eks-rt.id}"
}

resource "aws_route_table_association" "eks-rt-association2" {
      subnet_id = "${aws_subnet.eks-node-subnet-pub2.id}"
      route_table_id = "${aws_route_table.eks-rt.id}"
}

#Route vi nat instance
resource "aws_route_table" "eks-rt-nat" {
      vpc_id = "${aws_vpc.eks-vpc.id}"
      route {
      cidr_block = "0.0.0.0/0"
      instance_id = "${aws_instance.nat.id}"
    }
}

#Route associate nat instance to private subnet2
resource "aws_route_table_association" "eks-rt-natinst-association2" {
      subnet_id = "${aws_subnet.eks-node-subnet-pri2.id}"
      route_table_id = "${aws_route_table.eks-rt-nat.id}"
}


#Route associate nat instance to private subnet1
resource "aws_route_table_association" "eks-rt-natinst-association1" {
      subnet_id = "${aws_subnet.eks-node-subnet-pri1.id}"
      route_table_id = "${aws_route_table.eks-rt-nat.id}"
}
