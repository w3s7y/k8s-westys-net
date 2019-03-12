#!/usr/bin/env bash

USAGE="$0 -o operation"

# Cluster name, state and networking details.
CLUSTER_NAME=${CLUSTER_NAME:-"k8s.westys.net"}
CLUSTER_STATE=s3://${CLUSTER_NAME}
DNS_ZONE=${DNS_ZONE:-"westys.net"}
AVAILABILITY_ZONES=${AVAILABILITY_ZONES:-"eu-west-1a,eu-west-1b,eu-west-1c"}
VPC_CIDR_BLOCK=${VPC_CIDR_BLOCK:-"172.10.0.0/16"}

# Master sizes & counts
MASTER_INSTANCES=${MASTER_INSTANCES:-"t2.micro"}
MASTER_COUNT=${MASTER_COUNT:-1}
MASTER_DISK_SIZE_GB=${MASTER_DISK_SIZE_GB:-8}

# Node sizes & counts
NODE_INSTANCES=${NODE_INSTANCES:-"t2.small"}
NODE_COUNT=${NODE_COUNT:-1}
NODE_DISK_SIZE_GB=${NODE_DISK_SIZE_GB:-16}


# Generate an ssh keypair for the cluster
function generate_ssh_keypair
{
    echo "Generating ssh keypair for cluster, please give a pass phrase."
    ssh-keygen -t rsa -b 4096 -f ${HOME}/.ssh/k8s_id_rsa
}

# Create a "baby" cluster.
function create_cluster
{
    kops create cluster \
    --name=${CLUSTER_NAME} --state=${CLUSTER_STATE} --dns-zone=${DNS_ZONE} \
    --zones=${AVAILABILITY_ZONES} --network-cidr=${VPC_CIDR_BLOCK} \
    --master-count=${MASTER_COUNT} --master-size=${MASTER_INSTANCES} --master-volume-size=${MASTER_DISK_SIZE_GB} \
    --node-count=${NODE_COUNT} --node-size=${NODE_INSTANCES} --node-volume-size=${NODE_DISK_SIZE_GB} \
    --ssh-public-key=${HOME}/.ssh/k8s_id_rsa.pub --yes
}

function update_cluster
{
    kops update cluster ${CLUSTER_NAME} --state=${CLUSTER_STATE} --yes
    kops rolling-update cluster ${CLUSTER_NAME} --state=${CLUSTER_STATE} --yes
}

function get_opts
{
    while getopts o:h x
    do
        case ${x} in
            o)  export OPERATION=${OPTARG};;
            h|*) echo ${USAGE}; exit 1;;
        esac
    done
}

function main
{
    get_opts
    echo $OPERATION
}

main
