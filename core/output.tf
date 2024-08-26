output "aws_s3_bucket_name" {
  value = module.aws-tf.tf_state_s3_buckets_names["tf_state"]
}

output "aws_devops_core_ddb_table_name" {
  value = module.aws-tf.tf_state_ddb_table_names["tf_state"]
}