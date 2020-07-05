resource "aws_eks_cluster" "eks-cluster" {

   name = "${var.cluster-name}"
   role_arn = "${aws_iam_role.eksrole.arn}"

   vpc_config {
      security_group_ids = ["${aws_security_group.eks-cluster-sg.id}"]
      #subnet_ids = ["${aws_subnet.eks-node-subnet-pub.*.id}"]
      subnet_ids = ["${aws_subnet.eks-node-subnet-pri1.id}", "${aws_subnet.eks-node-subnet-pri2.id}","${aws_subnet.eks-node-subnet-pub1.id}","${aws_subnet.eks-node-subnet-pub2.id}"]

   }

   depends_on = [
      aws_iam_role_policy_attachment.eksrole-AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.eksrole-AmazonEKSServicePolicy,
   ]
}
