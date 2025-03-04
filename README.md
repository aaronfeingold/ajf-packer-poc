# Fedora ML Training AMI Builder

This repository contains Packer configurations to build Amazon Machine Images (AMIs) optimized for machine learning training workloads on Fedora Linux.

## Overview

This Packer project creates an EC2 AMI based on Fedora 41, configured with all the necessary tools and dependencies for ML training. It leverages an external Ansible repository for system configuration.
Prerequisites

## Packer (v1.7.0+)

AWS CLI installed and configured with appropriate permissions
Git

Project Structure

```
├── fedora_ml_image.pkr.hcl    # Main Packer configuration
├── variables.pkr.hcl          # Variable definitions
├── build.sh                   # Build script
└── README.md                  # This file
```

## Quick Start

Clone this repository:

```sh
git clone https://github.com/yourusername/packer-fedora-ml.git
cd packer-fedora-ml
```

Make the build script executable:

```sh
chmod +x build.sh
```

Build the AMI with default settings:

```sh
./build.sh
```

Or customize the build:

```sh
./build.sh --instance-type t3.large --region us-west-2 --ansible-repo https://github.com/yourname/your-ansible-repo.git
```

## Configuration Options

You can customize the build using the following parameters in the build script:

| Parameter       | Description                            | Default                                          |
| --------------- | -------------------------------------- | ------------------------------------------------ |
| --instance-type | EC2 instance type for building the AMI | t3.medium                                        |
| --region        | AWS region where the AMI will be built | us-east-1                                        |
| --ansible-repo  | URL of the Ansible repository to use   | https://github.com/aaronfeingold/ajf-ansible.git |
| --source-ami    | Base AMI ID to use                     | ami-09722669c73b517f6 (Fedora 41)                |
| --ami-name      | Name prefix for the generated AMI      | ajf-fedora-ml-training                           |

## How It Works

1. Launches a temporary EC2 instance based on Fedora 41
2. Installs prerequisites (git, ansible, python)
3. Clones the specified Ansible repository
4. Runs the Ansible playbook to configure the system
5. Cleans up temporary files
6. Creates an AMI from the configured instance
7. Terminates the temporary instance

## Ansible Integration

This Packer configuration expects an Ansible repository with the following structure:

```
├── playbook.yml # Main playbook
├── inventory.ini # Inventory file
├── roles/ # Roles directory
├── setup/prerequisites # Setup script
└── run_playbook # Playbook execution script
```

The Ansible playbook should handle the installation and configuration of all ML-related tools and dependencies.

It can be cloned from github (see below for configuring github access).

## Environment Configuration

This project uses environment variables for sensitive configuration.

1. Copy the example environment file:
```sh
cp .env.example .env
```

2. Edit the .env file and add your GitHub personal access token:
```sh
GITHUB_TOKEN=your_github_token_here
```

3. Ensure your .env file is never committed to git (it should be gitignored by default)

## Cost Efficiency

This build process is optimized for cost efficiency:

- Uses a moderate-sized instance type for building
- Packages all dependencies into the AMI to reduce instance startup time
- Cleans package caches to reduce AMI size
- Configures the system for optimal ML training performance

## Troubleshooting

If the build fails:

- Check AWS credentials and permissions
- Verify connectivity to the Ansible repository
- Examine Packer logs for specific error messages
- Ensure the Ansible playbook is compatible with Fedora 41
