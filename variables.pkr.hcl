variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where the AMI will be built"
}

variable "ami_name" {
  type        = string
  default     = "ajf-fedora-ml-training"
  description = "The name prefix for the generated AMI"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "The EC2 instance type used to build the AMI"
}

variable "ansible_repo" {
  type        = string
  default     = "aaronfeingold/ajf-ansible"
  description = "The Git repository URL for the Ansible playbooks"
}

variable "source_ami" {
  type        = string
  default     = "ami-09722669c73b517f6"
  description = "The source AMI ID (Fedora-Cloud-Base-AmazonEC2-41-1.4-x86_64)"
}
