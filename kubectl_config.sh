#!/usr/bin/env bash
#kubectl download and install
if [[ ! -e /usr/local/bin/kubectl ]]
then
   curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
   chmod 755 ./kubectl
   sudo mv ./kubectl /usr/local/bin/kubectl
else
   echo "Already kubectl downloaded and installed"
fi
   


#aws-iam-authenticator download and install
echo "download  aws-iam-authenticator and install"
if [[ ! -e /usr/local/bin/aws-iam-authenticator ]]
then
    curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
    chmod 755 ./aws-iam-authenticator	
    sudo mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
else
   echo "Already aws-iam-authentiator downloaded and installed"
fi


CLUSTER-NAME="terraform-eks-demo"
REGION="ap-northeast-2"
#
aws eks --region $REGION update-kubeconfig --name $CLUSTER-NAME
