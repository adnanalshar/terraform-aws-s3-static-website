# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

variables {

  # Test Remote State Resources
  tf_remote_state_resource_configs = {
    # Custom Terraform Module Repo
    test_tf_remote_state_config_1 : {
      prefix = "test-tf-remote-state-config-1"
    },
  }
}

# - Unit Tests -
run "input_validation" {
  command = plan

  variables {

    tf_remote_state_resource_configs = {
      # Custom Terraform Module Repo
      test_tf_remote_state_config_1 : {
        prefix = "this_is_a_prefix_name_and_it_is_longer_than_40_characters_and_will_fail"
      },
    }

  }

  expect_failures = [
    var.tf_remote_state_resource_configs,
  ]
}

# - End-to-end Tests -
run "e2e_test" {
  command = apply

  # Assertions
  # S3 Remote State - Ensure S3 Remote State buckets have correct names after creation
  assert {
    condition     = startswith(aws_s3_bucket.tf_remote_state_s3_buckets["test_tf_remote_state_config_1"].id, "test-tf-remote-state-config-1")
    error_message = "The S3 Remote State Bucket name (${aws_s3_bucket.tf_remote_state_s3_buckets["test_tf_remote_state_config_1"].id}) did not start with the expected value (test-tf-remote-state-config-1)."
  }

  # DynamoDB Terraform State Lock Table - Ensure DynamoDB Terraform State Lock Tables have correct names after creation
  assert {
    condition     = startswith(aws_dynamodb_table.tf_remote_state_lock_tables["test_tf_remote_state_config_1"].id, "test-tf-remote-state-config-1")
    error_message = "The DynamoDB Terraform State Lock table name (${aws_dynamodb_table.tf_remote_state_lock_tables["test_tf_remote_state_config_1"].id}) did not start with the expected value (test-tf-remote-state-config-1)."
  }
}
