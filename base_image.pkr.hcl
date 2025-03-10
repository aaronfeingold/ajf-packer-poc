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

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 80
    volume_type = "gp3"
    delete_on_termination = true
  }

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

  provisioner "shell" {
    inline = [
      "sudo dnf install -y git ansible python3 python3-pip",
    ]
  }

  # Clone the Ansible repository
  provisioner "shell" {
    inline = [
      "git clone https://${var.github_token}@github.com/${var.ansible_repo}.git ~/ansible-repo",
      "cd ~/ansible-repo",
      "chmod +x run_playbook",
      "./run_playbook \"--tags base\" true" // Run the base playbook and add the cdnvm to user bashrc
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -rf ~/ansible-repo",
      "sudo dnf clean all",
      "cat /dev/null > ~/.bash_history",
      "history -c",
      "echo 'Cleanup complete'"
    ]
  }
}
