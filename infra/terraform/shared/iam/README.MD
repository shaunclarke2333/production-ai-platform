# shared/iam: GHA OIDC

IAM OIDC resource that gives GHA the ability to assume roles in AWS.

## Why it's built this way
- No lon lived keys, this removes the risk of keys being compromised.
- Trust policy scoped only to a specific repo, to enforce the principle of least previlige.
- The policy is scoped to main branch only and validates the OIDC token's audience claim. This prevents any workflow from unapproved branches from getting any credentials.
- the CI role uses least privilege permissions scoped to ECR push only, not broad AWS access, and widens deliberately as phases need it.

## Depends on
- No dependencies

## Inputs / outputs
- Inputs: url, client_id_list, policy name, role name, policy arn
- Outputs: ci_deploy_role_arn

## How to apply
```bash
cd infra/terraform/shared/iam
terraform init
terraform apply
```