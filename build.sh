#!/bin/bash

set -e

# Default values
INSTANCE_TYPE="t3.medium"
REGION="us-east-1"
ANSIBLE_REPO="https://github.com/aaronfeingold/ajf-ansible.git"
SOURCE_AMI="ami-09722669c73b517f6"
AMI_NAME="ajf-fedora-ml-training"

# Parse command-line options
while [[ $# -gt 0 ]]; do
  case $1 in
    --instance-type)
      INSTANCE_TYPE="$2"
      shift 2
      ;;
    --region)
      REGION="$2"
      shift 2
      ;;
    --ansible-repo)
      ANSIBLE_REPO="$2"
      shift 2
      ;;
    --source-ami)
      SOURCE_AMI="$2"
      shift 2
      ;;
    --ami-name)
      AMI_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./build.sh [--instance-type TYPE] [--region REGION] [--ansible-repo URL] [--source-ami AMI_ID] [--ami-name NAME]"
      exit 1
      ;;
  esac
done

echo "Building ML Training AMI..."
echo "Instance Type: $INSTANCE_TYPE"
echo "Region: $REGION"
echo "Ansible Repo: $ANSIBLE_REPO"
echo "Source AMI: $SOURCE_AMI"
echo "AMI Name Prefix: $AMI_NAME"

# Initialize Packer
packer init .

# Build the AMI - Packer will automatically use both HCL files
packer build \
  -var="instance_type=$INSTANCE_TYPE" \
  -var="aws_region=$REGION" \
  -var="ansible_repo=$ANSIBLE_REPO" \
  -var="source_ami=$SOURCE_AMI" \
  -var="ami_name=$AMI_NAME" \
  .

# Get the AMI ID
AMI_ID=$(aws ec2 describe-images --owners self --filters "Name=name,Values=${AMI_NAME}*" --query 'sort_by(Images, &CreationDate)[-1].ImageId' --output text --region $REGION)
if [ -n "$AMI_ID" ]; then
  echo "Created AMI: $AMI_ID"
fi

echo "Build complete"
