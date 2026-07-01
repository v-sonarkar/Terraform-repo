output "name_tag" {
  description = "Computed Name tag from module"
  value       = module.ec2_s3.name_tag
}

output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.ec2_s3.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.ec2_s3.bucket_arn
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_s3.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_s3.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2_s3.public_dns
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_s3.private_ip
}
