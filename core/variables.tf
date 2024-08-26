variable "aws_region" {
  type        = string
  description = "The AWS region you wish to deploy your resources to."
  default     = "eu-central-1"
}

variable "tf_remote_state_resource_configs" {
  type = map(object({
    prefix           = optional(string, "my-prefix")
    ddb_billing_mode = optional(string, "PAY_PER_REQUEST")
    ddb_hash_key     = optional(string, "LockID")
  }))
  description = "Configurations for Terraform State Resources"
  default     = {}

  validation {
    condition     = alltrue([for config in values(var.tf_remote_state_resource_configs) : length(config.prefix) > 3 && length(config.prefix) <= 40])
    error_message = "The prefix of one of the defined Terraform Remote State Resource Configs is too long. A prefix can be a maxmium of 40 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all prefixes are 40 characters or less, and try again."
  }

  validation {
    condition     = alltrue([for config in values(var.tf_remote_state_resource_configs) : config.ddb_billing_mode == "PAY_PER_REQUEST" || config.ddb_billing_mode == "PROVISIONED"])
    error_message = "The DynamoDB Billing Mode ('ddb_billing_mode') of one of the defined Terraform Remote State Resource Configs is not an accepted value. Valid values for DynamoDB Billing Mode are 'PAY_PER_REQUEST' or 'PROVISIONED'. Please ensure the 'ddb_billing_mode' is set to one of these values and try again."
  }
}