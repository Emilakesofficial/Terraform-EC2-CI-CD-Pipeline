output "instance_id" {
  description = "ID of the EC2 instance."
  value       = module.ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = module.ec2.public_dns
}

output "security_group_id" {
  description = "ID of the security group attached to the instance."
  value       = module.ec2_security_group.security_group_id
}

output "ssh_command" {
  description = "SSH command if key_name and SSH access are configured."
  value       = var.key_name != null && var.enable_ssh ? "ssh -i /path/to/${var.key_name}.pem ec2-user@${module.ec2.public_ip}" : "SSH is disabled or key_name is not set."
}
