variable "project" {
  description = "The project name"
  type        = string
  default     = "github-poc"
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "Tags for the bucket"
  type        = map(string)
  default = {
    Project     = "globals-ms"
    Environment = "dev"
  }
}

variable "vpc_id" {
  description = "The VPC ID to deploy resources"
  default     = "vpc-0bb93f2c0dd0ca413" // VPC ID on dev
}

variable "private_subnet_ids" {
  description = "The Subnet IDs to deploy resources"
  type        = list(string)
  default     = ["subnet-00ffb8c2d63dfd53f", "subnet-06f6d833fb8735c1c"] // Subnet IDs on dev
}

variable "public_subnet_ids" {
  description = "The Subnet IDs to deploy resources"
  type        = list(string)
  default     = ["subnet-0df3dad7a8cd0f2b7", "subnet-021d6b42b7e137f8c"] // Subnet IDs on dev
}

variable "default_security_group_id" {
  description = "The Security Group IDs to deploy resources"
  type        = string
  default     = "sg-0c98182f618919030" // Security Group ID on dev
}

variable "logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the number of days you want to retain log events"
}