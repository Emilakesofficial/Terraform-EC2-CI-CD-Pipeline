variable "aws_region" {
  description = "AWS region where the EC2 instance will be created."
  type        = string
  default     = "us-west-2"
}

variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
  default     = "cicd-project"
}

variable "instance_type" {
  description = "Small EC2 instance type for learning. Use t2.micro or t3.micro for free-tier eligible accounts where available."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional existing EC2 key pair name for SSH."
  default     = null
}

variable "enable_ssh" {
  description = "Whether to allow inbound SSH on port 22."
  type        = bool
  default     = false
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance. Use your own public IP as x.x.x.x/32 if enable_ssh is true."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags applied to created resources."
  type        = map(string)
  default = {
    Project     = "ci-cd-learning"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
