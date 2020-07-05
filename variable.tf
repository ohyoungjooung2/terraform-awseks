variable "cluster-name" {
   default = "terraform-eks-demo"
   type = string
}

variable "aws_region" {
   default = "ap-northeast-2"
   type = string
}


variable "aws_nat_ami" {
    default = {
        ap-northeast-2 = "ami-0a7f5342e82d8ae53"
    }
}
