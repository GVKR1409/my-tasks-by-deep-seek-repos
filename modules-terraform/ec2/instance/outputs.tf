# Output the instance ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

# Output the public IP address
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

# Output the private IP address
output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

# Output the instance ARN
output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

# Output the Elastic IP (if associated)
output "elastic_ip" {
  description = "The Elastic IP associated with the instance"
  value       = var.associate_elastic_ip ? aws_eip.this[0].public_ip : null
}
