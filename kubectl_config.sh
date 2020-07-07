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
