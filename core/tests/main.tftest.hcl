# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

variables {

  # Test Remote State Resources
  tf_remote_state_resource_configs = {
    # Custom Terraform Module Repo
    tf_state : {
      prefix = "aws-terraform-s3-static-website-tfstate"
    }
  }
}

# - Unit Tests -
run "input_validation" {
  command = plan

  variables {

    tf_remote_state_resource_configs = {
      # Custom Terraform Module Repo
      tf_state : {
        prefix = "aws-terraform-s3-static-website-tfstate"
      },
    }

  }
}

# - End-to-end Tests -
run "e2e_test" {
  command = apply

  module {
    source = "../module/"
  }

  # Assertions
  # S3 Remote State - Ensure S3 Remote State buckets have correct names after creation
  assert {
    condition     = startswith(aws_s3_bucket.tf_remote_state_s3_buckets["tf_state"].id, "aws-terraform-s3-static-website-tfstate")
    error_message = "The S3 Remote State Bucket name (${aws_s3_bucket.tf_remote_state_s3_buckets["tf_state"].id}) did not start with the expected value (aws-terraform-s3-static-website-tfstate)."
  }

  # DynamoDB Terraform State Lock Table - Ensure DynamoDB Terraform State Lock Tables have correct names after creation
  assert {
    condition     = startswith(aws_dynamodb_table.tf_remote_state_lock_tables["tf_state"].id, "aws-terraform-s3-static-website-tfstate")
    error_message = "The DynamoDB Terraform State Lock table name (${aws_dynamodb_table.tf_remote_state_lock_tables["tf_state"].id}) did not start with the expected value (aws-terraform-s3-static-website-tfstate)."
  }
}
