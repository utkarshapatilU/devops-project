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

# -------- WAIT FOR SSH --------
resource "null_resource" "wait_for_ssh" {
  depends_on = [aws_instance.server]

  provisioner "remote-exec" {
    inline = ["echo 'EC2 is ready for SSH'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.server.public_ip
      private_key = file(var.ssh_private_key_path)
      timeout     = "10m"
    }
  }
}

# -------- ANSIBLE RUN --------
resource "null_resource" "ansible_run" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOT
      echo "[servers]" > ../Ansible/inventory.ini
      echo "${aws_instance.server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.ssh_private_key_path}" >> ../Ansible/inventory.ini

      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i ../Ansible/inventory.ini ../Ansible/playbook.yml \
      --ssh-extra-args="-o StrictHostKeyChecking=no"
    EOT
  }
}
