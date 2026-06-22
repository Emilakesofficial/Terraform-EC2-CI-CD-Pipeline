terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use the default VPC/subnets so this stays small and beginner-friendly.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2023 x86_64 AMI from AWS Systems Manager Parameter Store.
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.name_prefix}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress_with_cidr_blocks = var.enable_ssh ? [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_blocks = var.ssh_cidr
    }
  ] : []

  egress_rules = ["all-all"]

  tags = var.tags
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}-ec2"

  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [module.ec2_security_group.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    dnf update -y
    dnf install -y git docker
    systemctl enable --now docker
    usermod -aG docker ec2-user
  EOF

  tags = var.tags
}
