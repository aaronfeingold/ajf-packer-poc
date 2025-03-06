#!/bin/bash

set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Default values
INSTANCE_TYPE="t3.medium"
REGION="us-east-1"
ANSIBLE_REPO="aaronfeingold/ajf-fedora-workstation-ansible"
SOURCE_AMI="ami-09722669c73b517f6"
AMI_NAME="ajf-fedora-ml-training"
GITHUB_TOKEN=${GITHUB_TOKEN:-""}  # Use env var if available

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
    --github-token)
      GITHUB_TOKEN="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./build.sh [--instance-type TYPE] [--region REGION] [--ansible-repo OWNER/REPO] [--source-ami AMI_ID] [--ami-name NAME] [--github-token TOKEN]"
      exit 1
      ;;
  esac
done

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
  # Prompt for token if not provided
  read -sp "Enter GitHub token: " GITHUB_TOKEN
  echo
fi

# Validate GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GitHub token is required. Provide it with --github-token or in the .env file."
  exit 1
fi

echo "Building ML Training AMI..."
echo "Instance Type: $INSTANCE_TYPE"
echo "Region: $REGION"
echo "Ansible Repo: $ANSIBLE_REPO"
echo "Source AMI: $SOURCE_AMI"
echo "AMI Name Prefix: $AMI_NAME"
echo "GitHub Token: [REDACTED]"

# Initialize Packer
packer init .

# Build the AMI
packer build \
  -var="instance_type=$INSTANCE_TYPE" \
  -var="aws_region=$REGION" \
  -var="ansible_repo=$ANSIBLE_REPO" \
  -var="source_ami=$SOURCE_AMI" \
  -var="ami_name=$AMI_NAME" \
  -var="github_token=$GITHUB_TOKEN" \
  .

# Get the AMI ID
AMI_ID=$(aws ec2 describe-images --owners self --filters "Name=name,Values=${AMI_NAME}*" --query 'sort_by(Images, &CreationDate)[-1].ImageId' --output text --region $REGION)
if [ -n "$AMI_ID" ]; then
  echo "Created AMI: $AMI_ID"
fi

echo "Build complete"
