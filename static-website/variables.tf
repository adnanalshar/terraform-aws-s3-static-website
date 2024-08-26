variable "aws_region" {
  type        = string
  description = "The AWS region you wish to deploy your resources to."
  default     = "eu-central-1"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  default     = "<your-domain-name>"
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
  default     = "<your-domain-name>"
}

variable "s3_public_access_block" {
  type        = bool
  default     = false
  description = "Conditional enabling of S3 Public Access Block."
}
