# This allows us to access outputs from the VPC remote state file in this environment.
# This is necessary because the VPC is created in a separate environment and we need to reference its outputs here.
data "terraform_remote_state" "vpc" {
    backend  = "s3"
    config = {
        bucket = var.state_bucket
        key = var.vpc_state_key
        region = var.region
    }
}