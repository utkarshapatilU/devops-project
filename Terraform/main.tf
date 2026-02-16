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

resource "null_resource" "ansible_run" {
  depends_on = [aws_instance.server]

  connection {
    type        = "ssh"
    host        = aws_instance.server.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    timeout     = "5m"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "[server]" > ../Ansible/inventory.ini
      echo "${aws_instance.server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.ssh_private_key_path}" >> ../Ansible/inventory.ini
      ansible-playbook -i ../Ansible/inventory.ini ../Ansible/playbook.yml
    EOT
  }
}


