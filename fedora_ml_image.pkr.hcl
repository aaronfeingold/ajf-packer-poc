packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "fedora" {
  ami_name      = "${var.ami_name}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "fedora"
  communicator  = "ssh"
  ssh_timeout   = "20m"

  tags = {
    Name        = var.ami_name
    Environment = "development"
    Builder     = "packer"
    Purpose     = "ML Training"
    BaseAMI     = "Fedora-Cloud-Base-AmazonEC2-41-1.4-x86_64"
  }
}

build {
  sources = ["source.amazon-ebs.fedora"]

  # Run bootstrap script to install prerequisites
  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y git ansible python3 python3-pip",
      "mkdir -p ~/ansible-playbooks"
    ]
  }

  # Clone the Ansible repository
  provisioner "shell" {
    inline = [
      "git clone https://${var.github_token}@github.com/${var.ansible_repo}.git ~/ansible-repo",
      "cd ~/ansible-repo",
      "chmod +x setup/prerequisites",
      "./setup/prerequisites",
      "chmod +x run_playbook",
      "./run_playbook"
    ]
  }

  # Clean up
  provisioner "shell" {
    inline = [
      # Remove git repositories and temporary files
      "rm -rf ~/ansible-repo",

      # Clean package cache to reduce image size
      "sudo dnf clean all",

      # Clear bash history
      "cat /dev/null > ~/.bash_history",
      "history -c",

      "echo 'Cleanup complete'"
    ]
  }
}
