# Create an EC2 instance
resource "aws_instance" "this" {
  ami                         = var.ami_id                  # AMI ID for the instance
  instance_type               = var.instance_type           # Instance type (e.g., t2.micro)
  subnet_id                   = var.subnet_id               # Subnet ID where the instance will be launched
  vpc_security_group_ids      = var.security_groups         # List of security group IDs
  key_name                    = var.key_name                # SSH key pair name
  user_data                   = var.user_data               # User data script for bootstrapping
  iam_instance_profile        = var.iam_instance_profile    # IAM instance profile
  associate_public_ip_address = var.associate_public_ip     # Associate a public IP
  monitoring                  = var.monitoring              # Enable detailed monitoring
  tenancy                     = var.tenancy                 # Tenancy (default, dedicated, host)
  placement_group             = var.placement_group         # Placement group for the instance
  cpu_core_count              = var.cpu_core_count          # Number of CPU cores
  cpu_threads_per_core        = var.cpu_threads_per_core    # Threads per CPU core
  hibernation                 = var.hibernation             # Enable/disable hibernation
  disable_api_termination     = var.disable_api_termination # Protect against termination

  # Root block device configuration
  root_block_device {
    volume_size = var.root_volume_size       # Size of the root volume in GB
    volume_type = var.root_volume_type       # Type of the root volume (e.g., gp2, io1)
    encrypted   = var.root_volume_encrypted  # Enable encryption for the root volume
    kms_key_id  = var.root_volume_kms_key_id # KMS key for encryption
  }

  # Additional EBS volumes
  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      encrypted             = ebs_block_device.value.encrypted
      kms_key_id            = ebs_block_device.value.kms_key_id
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  # Network interface configuration
#  network_interface {  
#    network_interface_id = aws_network_interface.this.id
#    device_index         = 0
#  }

  # Metadata options
#  metadata_options {
#    http_endpoint               = var.metadata_http_endpoint
#    http_tokens                 = var.metadata_http_tokens
#    http_put_response_hop_limit = var.metadata_http_hop_limit
#  }

  # Credit specification for T2/T3 instances
#  credit_specification {
#    cpu_credits = var.cpu_credits
#  }

  # Add tags to the instance
  tags = merge(var.tags, local.default_tags)
}

# Create an Elastic IP and associate it with the instance
resource "aws_eip" "this" {
  count    = var.associate_elastic_ip ? 1 : 0
  instance = aws_instance.this.id
  tags     = var.tags
}

# Create a network interface
#resource "aws_network_interface" "this" {
#  subnet_id       = var.subnet_id
#  private_ips     = var.private_ips
#  security_groups = var.security_groups
#  tags            = merge(var.tags, local.default_tags)
#}
