
output "ansible_master_public_ip" {
  value = aws_instance.ansible_master.public_ip
}

output "worker_public_ips" {
  value = aws_instance.worker_nodes[*].public_ip
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}
