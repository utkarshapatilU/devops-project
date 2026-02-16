variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = "jenkins-key"
}

variable "instance_name" {
  description = "EC2 instance name tag"
  type        = string
  default     = "Ansible-Server"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file (used by Terraform/Ansible)"
  type        = string
  default     = "./jenkins-key.pem"  # relative to Terraform folder
}


