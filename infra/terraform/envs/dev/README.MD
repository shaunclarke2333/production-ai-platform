# envs/dev: EKS cluster

The hand rolled Kubernetes cluster the platform runs on

## Why it's built this way
- I hand rolled the cluster instead of using terraform-aws-modules/eks, to have full control and visibility; every resource is visible and config can be understood.
- Chose to go with one shared cluster with namespaces separating environments, not a cluster per environment, this controls cost.
- Chose pod identity over IRSA becasue it offers a more streamlined and scalable way for pods to access AWS services.

## Depends on
- shared/vpc (reads vpc_id and private_subnet_ids via remote state)

## Inputs/Outputs
- Inputs: region, cluster name, node group sizing(from dev.auto.tfvars)
- Outputs: none; the cluster is accessed via kubeconfig 

## How to apply
```bash
cd infra/terraform/envs/dev
terraform init
terraform apply
aws eks update-kubeconfig --name production-ai-platform-shared-eks-cluster --region us-west-2
```
