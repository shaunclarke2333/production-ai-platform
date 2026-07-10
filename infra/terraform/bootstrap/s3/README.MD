# bootstrap/s3

The s3 bucket that manages Terraform's state file.

## Why it's built this way
- Using the s3 remote state automatically versions the state file and prevents conflict through shared access.
- s3 allows for native state locking, which which prevents concurrent, conflicting writes that can corrupt data.

## Depends on
- No dependencies

## Inputs / outputs
- Inputs: Region, bucket name
- Outputs: none

## How to apply
```bash
cd infra/terraform/bootstrap/s3
terraform init
terraform apply
```
