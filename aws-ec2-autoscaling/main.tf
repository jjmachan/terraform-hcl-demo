terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

################################################################################
# Input variable definitions
################################################################################

variable "deployment_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "region" {
  type = string
}

variable "ami" {
  type = string
}

################################################################################
# Resource definitions
################################################################################

resource "aws_iam_role" "ec2_role" {
  name = "${var.deployment_name}-iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      }
    ]
  })
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "ip" {
  name = "${var.deployment_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "app_server" {
  launch_template {
    id = aws_launch_template.lt.id
  }
}

resource "aws_launch_template" "lt" {
  name                   = "${var.deployment_name}-lt"
  image_id               = var.ami
  instance_type          = var.instance_type
  update_default_version = true
  user_data              = filebase64("startup_script.sh")
  security_group_names   = ["bentoml"]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ip.arn
  }
}

################################################################################
# Output value definitions
################################################################################
