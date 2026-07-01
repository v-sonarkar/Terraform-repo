variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "my-module-bucket"
}

variable "bucket_tag_name" {
  description = "Name tag for the S3 bucket"
  type        = string
  default     = "Mys3Bucket"
}
