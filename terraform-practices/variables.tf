variable "ec2_instance_name" {
  description = "This variable holds EC2 instance name"
  default     = "terra-automate-server"
  type        = string
}

variable "ec2_volume_size" {
  description = "This variable holds EC2 volume size"
  default     = 10
  type        = number
}

variable "ec2_volume_type" {
  description = "This variable holds EC2 volume type"
  default     = "gp3"
  type        = string
}
variable "ec2_instance_state" {
  description = "This variable holds EC2 instance state"
  default     = "stopped"
  type        = string
}
variable "ec2_instance_count"{
    type=number
    default = 2
}

variable "project_name" {
  description = "Project name, used as a prefix for resource names"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

############################
# Networking
############################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.0.0.0/16"
}

variable "availability_zones" {
  description = "Two availability zones for the subnets"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly 2 availability zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the 2 public subnets"
  type        = list(string)
  default     = ["172.0.1.0/24", "172.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the 2 private subnets"
  type        = list(string)
  default     = ["172.0.11.0/24", "172.0.12.0/24"]
}

