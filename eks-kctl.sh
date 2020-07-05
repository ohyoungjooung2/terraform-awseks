#!/usr/bin/env bash
NAME="terraform-eks-demo"
aws eks --region ap-northeast-2 update-kubeconfig --name $NAME
