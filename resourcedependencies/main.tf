provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_tag    = var.instance_type == "t3.micro" ? "Miceo Instance" : "Standard Instance"
  bucket_name = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name
  tags = {
    Name = "Mys3Bucket"
  }
}
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name = local.name_tag
  }
  depends_on=[
    aws_s3_bucket.my_bucket
  ]
}
