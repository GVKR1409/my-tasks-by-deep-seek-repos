To create a **comprehensive Terraform module for AWS EC2** that includes **all major features and configurations**, I'll expand the module to include the following:

1. **Instance Profile (IAM Role)**
2. **Elastic IP Association**
3. **Network Interface Configuration**
4. **EBS Volumes (Additional Block Devices)**
5. **Placement Groups**
6. **Tenancy**
7. **Monitoring**
8. **Metadata Options**
9. **Credit Specification (for T2/T3 instances)**
10. **CPU Options**
11. **Hibernation Options**

Here’s the updated and detailed EC2 module:

---

### **Directory Structure**

```
modules/
  ec2/
    main.tf
    variables.tf
    outputs.tf
```

---

### **`modules/ec2/main.tf`**

```hcl
# Create an EC2 instance
resource "aws_instance" "this" {
  ami                    = var.ami_id          # AMI ID for the instance
  instance_type          = var.instance_type   # Instance type (e.g., t2.micro)
  subnet_id              = var.subnet_id       # Subnet ID where the instance will be launched
  vpc_security_group_ids = var.security_groups # List of security group IDs
  key_name               = var.key_name        # SSH key pair name
  user_data              = var.user_data       # User data script for bootstrapping
  iam_instance_profile   = var.iam_instance_profile # IAM instance profile
  associate_public_ip_address = var.associate_public_ip # Associate a public IP
  monitoring             = var.monitoring      # Enable detailed monitoring
  tenancy                = var.tenancy         # Tenancy (default, dedicated, host)
  placement_group        = var.placement_group # Placement group for the instance
  cpu_core_count         = var.cpu_core_count  # Number of CPU cores
  cpu_threads_per_core   = var.cpu_threads_per_core # Threads per CPU core
  hibernation            = var.hibernation     # Enable/disable hibernation
  disable_api_termination = var.disable_api_termination # Protect against termination

  # Root block device configuration
  root_block_device {
    volume_size = var.root_volume_size # Size of the root volume in GB
    volume_type = var.root_volume_type # Type of the root volume (e.g., gp2, io1)
    encrypted   = var.root_volume_encrypted # Enable encryption for the root volume
    kms_key_id  = var.root_volume_kms_key_id # KMS key for encryption
  }

  # Additional EBS volumes
  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      encrypted   = ebs_block_device.value.encrypted
      kms_key_id  = ebs_block_device.value.kms_key_id
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  # Network interface configuration
  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  # Metadata options
  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_hop_limit
  }

  # Credit specification for T2/T3 instances
  credit_specification {
    cpu_credits = var.cpu_credits
  }

  # Add tags to the instance
  tags = merge(
    var.tags,
    {
      Name = var.instance_name # Name tag for the instance
    }
  )
}

# Create an Elastic IP and associate it with the instance
resource "aws_eip" "this" {
  count    = var.associate_elastic_ip ? 1 : 0
  instance = aws_instance.this.id
  tags     = var.tags
}

# Create a network interface
resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = var.security_groups
  tags            = var.tags
}
```

---

### **`modules/ec2/variables.tf`**

```hcl
# Input variable for the AMI ID
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

# Input variable for the instance type
variable "instance_type" {
  description = "The type of instance to start (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
}

# Input variable for the subnet ID
variable "subnet_id" {
  description = "The subnet ID where the instance will be launched"
  type        = string
}

# Input variable for security group IDs
variable "security_groups" {
  description = "A list of security group IDs to associate with the instance"
  type        = list(string)
}

# Input variable for the SSH key pair name
variable "key_name" {
  description = "The name of the SSH key pair to use for the instance"
  type        = string
}

# Input variable for user data (bootstrapping script)
variable "user_data" {
  description = "The user data script to run when the instance starts"
  type        = string
  default     = ""
}

# Input variable for the root volume size
variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 20
}

# Input variable for the root volume type
variable "root_volume_type" {
  description = "The type of the root volume (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}

# Input variable for root volume encryption
variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = false
}

# Input variable for root volume KMS key
variable "root_volume_kms_key_id" {
  description = "The KMS key ID for root volume encryption"
  type        = string
  default     = ""
}

# Input variable for additional EBS volumes
variable "ebs_volumes" {
  description = "A list of additional EBS volumes to attach to the instance"
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    kms_key_id            = string
    delete_on_termination = bool
  }))
  default = []
}

# Input variable for the instance name
variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
}

# Input variable for additional tags
variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}

# Input variable for IAM instance profile
variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance"
  type        = string
  default     = ""
}

# Input variable for associating a public IP
variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance"
  type        = bool
  default     = false
}

# Input variable for enabling detailed monitoring
variable "monitoring" {
  description = "Whether to enable detailed monitoring for the instance"
  type        = bool
  default     = false
}

# Input variable for instance tenancy
variable "tenancy" {
  description = "The tenancy of the instance (default, dedicated, host)"
  type        = string
  default     = "default"
}

# Input variable for placement group
variable "placement_group" {
  description = "The placement group for the instance"
  type        = string
  default     = ""
}

# Input variable for CPU core count
variable "cpu_core_count" {
  description = "The number of CPU cores for the instance"
  type        = number
  default     = null
}

# Input variable for CPU threads per core
variable "cpu_threads_per_core" {
  description = "The number of threads per CPU core for the instance"
  type        = number
  default     = null
}

# Input variable for hibernation
variable "hibernation" {
  description = "Whether to enable hibernation for the instance"
  type        = bool
  default     = false
}

# Input variable for protecting against termination
variable "disable_api_termination" {
  description = "Whether to protect the instance against API termination"
  type        = bool
  default     = false
}

# Input variable for metadata options
variable "metadata_http_endpoint" {
  description = "Whether to enable the metadata HTTP endpoint"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether to require IMDSv2 tokens"
  type        = string
  default     = "optional"
}

variable "metadata_http_hop_limit" {
  description = "The HTTP hop limit for metadata requests"
  type        = number
  default     = 1
}

# Input variable for CPU credit specification
variable "cpu_credits" {
  description = "The CPU credit option for T2/T3 instances (standard or unlimited)"
  type        = string
  default     = "standard"
}

# Input variable for associating an Elastic IP
variable "associate_elastic_ip" {
  description = "Whether to associate an Elastic IP with the instance"
  type        = bool
  default     = false
}

# Input variable for private IPs
variable "private_ips" {
  description = "A list of private IPs to assign to the network interface"
  type        = list(string)
  default     = []
}
```

---

### **`modules/ec2/outputs.tf`**

```hcl
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
```

---

### **Using the EC2 Module**

Here’s an example of how to use the EC2 module in your main Terraform configuration:

```hcl
provider "aws" {
  region = "us-west-2"
}

module "ec2_instance" {
  source = "./modules/ec2"

  ami_id          = "ami-0c55b159cbfafe1f0" # Replace with your AMI ID
  instance_type   = "t2.micro"
  subnet_id       = "subnet-0123456789abcdef0" # Replace with your subnet ID
  security_groups = ["sg-0123456789abcdef0"]   # Replace with your security group ID(s)
  key_name        = "my-key-pair"              # Replace with your SSH key pair name
  instance_name   = "example-instance"
  root_volume_size = 30
  root_volume_type = "gp2"
  associate_elastic_ip = true
  iam_instance_profile = "my-instance-profile"
  metadata_http_tokens = "required"

  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
```

---

### **Key Features**

1. **Comprehensive Configuration**:
   - Supports all major EC2 features, including IAM roles, Elastic IPs, EBS volumes, metadata options, and more.

2. **Reusable and Modular**:
   - All configurations are passed as input variables, making the module reusable across different environments.

3. **Dynamic EBS Volumes**:
   - Allows attaching multiple EBS volumes with customizable configurations.

4. **Metadata Options**:
   - Supports IMDSv2 and other metadata configurations for enhanced security.

5. **Outputs**:
   - Outputs useful information like instance ID, public IP, private IP, ARN, and Elastic IP.

---

Let me know if you need further assistance! 😊
