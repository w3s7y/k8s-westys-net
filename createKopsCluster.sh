#!/usr/bin/env bash

# Generate an ssh keypair for the cluster
ssh-keygen -t rsa -b 4096 -P '' -f k8s_id_rsa

# Create a "baby" cluster.
kops create cluster --name=k8s-westys-net --state=k8s-westys-net --zones="eu-west-1a,eu-west-1b,eu-west-1c" \
--node-count=1 --master-count=1 --node-size=t2.micro --master-size=t2.micro \
--dns-zone=westys.net --yes

