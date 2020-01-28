resource "aws_security_group" "private" {
	name = "private"
	description = "Allow services from the private subnet through NAT"
	vpc_id = "${aws_vpc.eks-vpc.id}"

}


resource "aws_security_group" "eks-cluster-sg" {
        name = "terraform-eks-cluster-sg"
	description = "Cluster communication with worker nodes"
	vpc_id = "${aws_vpc.eks-vpc.id}"
        egress {
          from_port = 0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
          Name = "terraform-eks-cluster-sg"

        }
}
resource "aws_security_group" "node-sg" {
        name = "terraform-eks-node-sg"
	description = "Security group for all worker nodes in the cluster group"
	vpc_id = "${aws_vpc.eks-vpc.id}"
        egress {
          from_port = 0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
        tags = "${
          map(
          "Name" , "terraform-eks-node",
          "kubernetes.io/cluster/${var.cluster-name}","owned"
          )
        }"
}

#Group rules
resource "aws_security_group_rule" "node-ingress-self" {
        description = "Allow node to communicate with each other"
        from_port = 0
        protocol = "-1"
        security_group_id = "${aws_security_group.node-sg.id}"
        source_security_group_id = "${aws_security_group.node-sg.id}"
        to_port = 65535
        type = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
        description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
        from_port = 1025
        protocol = "tcp"
        security_group_id = "${aws_security_group.node-sg.id}"
        source_security_group_id = "${aws_security_group.eks-cluster-sg.id}"
        to_port = 65535
        type = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
        description = "Allow pods to communiate with the cluster API server"
        from_port = 443
        protocol = "tcp"
        security_group_id = "${aws_security_group.eks-cluster-sg.id}"
        source_security_group_id = "${aws_security_group.node-sg.id}"
        to_port = 65535
        type = "ingress"
}
