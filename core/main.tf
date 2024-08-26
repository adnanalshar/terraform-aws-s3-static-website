module "aws-tf" {
  source = "../module/"
  tf_remote_state_resource_configs = {
    tf_state : {
      prefix = "aws-terraform-s3-static-website-tfstate"
    }
  }
}