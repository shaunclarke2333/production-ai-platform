# shared/vpc: VPC

The isolated network space in AWS where the infrastructure will run.

## Why it's built this way
- 2 public subnets for public facing resources like NAT and ALB which are entrances to the VPC
- 2 private subnets for isolation and security of sensitive workloads
- NAT to allow resources on the private subnets to make outbound calls to the internet
- IGW allows internet access from the public subnets
- Route tables allow default route from public subnet to IGW for internet and default route from private subnet to NAT for outbound internet calls.
- Private subnets are tagged with kubernetes.io/role/internal-elb, this tells the AWS LB controller where to deploy internal load balancers.
- Public subnets are tagged with kubernetes.io/role/elb, this tells the AWS LB controller where to deploy the internet facing load balancers.
- All subnets are tagged with kubernetes.io/cluster/<cluster-name>, This identifies which subnets belong to a specific EKS cluster
- Subnets span 2 availability zones for high availability.

## Depends on
- No dependencies
- consumed by: envs/dev

## Inputs / outputs
- Inputs: IP CIDR block
- Outputs: public_subnet_ids, private_subnet_ids, vpc_id

## How to apply
```bash
cd infra/terraform/shared/vpc
terraform init
terraform apply
```
