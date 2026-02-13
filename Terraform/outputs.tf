output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.server.public_dns
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.server.id
}
