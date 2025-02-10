variable "aws_region" {
    default = "us-east-1"
  }

  variable "ami_name" {
    default = "ajf-fedora-ami"
  }

  source "amazon-ebs" "fedora" {
    ami_filter {
      filters = {
        name                = "Fedora-Cloud-Base-*-x86_64-*"
        architecture        = "x86_64"
        virtualization-type = "hvm"
      }
      owners = ["125523088429"] # Official Fedora AMI owner ID
      most_recent = true
    }

    instance_type = "t3.medium"
    region        = var.aws_region
    ssh_username  = "fedora"

    tags = {
      Name = var.ami_name
    }
  }

  build {
    sources = ["source.amazon-ebs.fedora"]

    provisioner "shell" {
      inline = [
        "sudo dnf update -y",
        "sudo dnf install -y git ansible"
      ]
    }

    provisioner "shell" {
      inline = [
        "git clone https://github.com/aaronfeingold/ajf-fedora-workstation-ansible.git /tmp/ansible",
        "cd /tmp/ansible && ansible-playbook main.yml"
      ]
    }

    post-processor "amazon-import" {
      regions = [var.aws_region]
    }
