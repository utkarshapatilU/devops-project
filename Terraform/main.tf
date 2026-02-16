provider "aws" {
  region = var.region
}

# -------- EC2 INSTANCE --------
resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
  }
}

# -------- ANSIBLE TRIGGER (SAFE) --------
resource "null_resource" "ansible_run" {
  depends_on = [aws_instance.server]

  # Connection block ensures Terraform waits until SSH is ready
  connection {
    type        = "ssh"
    host        = aws_instance.server.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/jenkins.pem")
    timeout     = "5m"
  }

  # Local-exec provisioner to run Ansible locally
  provisioner "local-exec" {
    command = <<EOT
      echo "[server]" > ../Ansible/inventory.ini
      echo "${aws_instance.server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/jenkins.pem" >> ../Ansible/inventory.ini
      ansible-playbook -i ../Ansible/inventory.ini ../Ansible/playbook.yml
    EOT
  }
}
