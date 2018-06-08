#!/usr/bin/env bash

# Generate an ssh keypair for the cluster
echo "Generating ssh keypair for cluster, please give a pass phrase."
# ssh-keygen -t rsa -b 4096 -f k8s_id_rsa

# Create a "baby" cluster.
kops create cluster --name=k8s.westys.net --state=s3://k8s.westys.net --zones="eu-west-1a,eu-west-1b,eu-west-1c" \
--node-count=1 --master-count=1 --node-size=t2.small --master-size=t2.micro \
--ssh-public-key=k8s_id_rsa.pub --dns-zone=westys.net --yes

