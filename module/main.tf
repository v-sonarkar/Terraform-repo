provider "aws" {
  region = var.aws_region
}

module "ec2_s3" {
  source = "./modules/ec2-s3"

  instance_type   = var.instance_type
  bucket_name     = var.bucket_name
  bucket_tag_name = var.bucket_tag_name
}
