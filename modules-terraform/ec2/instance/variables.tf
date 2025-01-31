# Input variable for the AMI ID
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "app_name" {
  description = "The AppName "
  type        = string
}

variable "environment" {
  description = "The AppName "
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
  default     = 8
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
