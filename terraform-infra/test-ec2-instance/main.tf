provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source = "../../modules-terraform/ec2/instance"

  ami_id          = var.ami_id # Replace with your AMI ID
  instance_type   = var.instace_type
  subnet_id       = var.subnet_id # Replace with your subnet ID
  security_groups = var.security_groups   # Replace with your security group ID(s)
  key_name        = var.keypair              # Replace with your SSH key pair name
  instance_name   = var.app_name
  //root_volume_size = 8
  //root_volume_type = "gp2"
  //associate_elastic_ip = true
  //iam_instance_profile = "my-instance-profile"
  //metadata_http_tokens = "required"
  environment = var.environment
  app_name = var.app_name
  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}

variable "environment" {
  default = "dev"
  type = string
  description = "Pass Specific Environment Name like dev/qa/uat"
}

variable "app_name" {
  default = "wos-cli"
  description = "Enter the App Name to deploy"
  type = string
}

variable "instace_type" {
 default = "t2.micro"
 description = "Enter Instance type"
 type = string
}


variable "keypair" {
  default = "mytest-key-pair"
}

variable "subnet_id" {
  default = "subnet-0b8e2cabd4d35c97b"
}

# Define an input variable for the EC2 instance AMI ID
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
  default = "ami-05fa46471b02db0ce"
}

variable "region" {
  default = "ap-south-1"
  description = "Enter the Region"
}

variable "security_groups" {
  default = ["sg-0f0ef928543adb872"]
  description = "Enter the Security Group ID"
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
