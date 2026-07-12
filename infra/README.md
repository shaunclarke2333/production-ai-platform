# Infrastructure teardown

This is a guide on how to tear down the infrastructure in the correct order so that no orphaned resources are left behind.

## Why order matters

`terraform destroy` only destroys the resources that Terraform itself created. Terraform is not aware of anything that ArgoCD or Helm created inside the cluster,
so those resources fall outside its state file and outside its cleanup radius.

Two things in this platform creates real AWS resources from inside Kubernetes:

- A Kubernetes LoadBalancer Service provisions an actual AWS load balancer. Terraform did not create it, so Terraform will not delete it.
- Prometheus requires persistent storage, so the monitoring stack provisions PersistentVolumeClaims during deployment that become real EBS volumes.

This causes two problems if you destroy in the wrong order:

1. **Orphaned resources keep billing.** Load balancers and EBS volumes survive the cluster and continue to cost money with nothing attached to them.
2. **The destroy can hang or fail.** Resources Terraform did not create, such as a load balancer's ENI, can hold the VPC open. Terraform then cannot delete the VPC and the destroy errors out or stalls.

The fix is to remove the in cluster workloads first, let Kubernetes clean up the AWS resources it provisioned, and only then run `terraform destroy`.

## Teardown steps

### 1. Delete the ArgoCD Applications

Deleting the Application tells ArgoCD to prune the workloads it deployed, which triggers Kubernetes to release the AWS resources those workloads created.

```bash
kubectl delete application kube-prometheus-stack -n argocd
kubectl delete application placeholder -n argocd
```

### 2. Confirm the AWS-backed Kubernetes resources are gone

Do not move on until both of these return nothing. This is the step that prevents orphaned resources.

```bash
# no PersistentVolumeClaims should remain, these are backed by real EBS volumes
kubectl get pvc -A

# no LoadBalancer services should remain these are backed by real AWS load balancers
kubectl get svc -A | grep LoadBalancer
```

### 3. Destroy the Terraform-managed infrastructure

```bash
cd infra/terraform/envs/dev
terraform destroy
```

### 4. Verify nothing was orphaned

Terraform reports success even if something it never knew about is still running, so check AWS directly.

Filter by the cluster's ownership tags. Other projects in this account may have their own load balancers and volumes, and those must not be touched. Kubernetes tags the AWS resources it provisions with the cluster name, so that tag is how you identify what belonged to this cluster and only this cluster.

```bash
CLUSTER=production-ai-platform-shared-eks-cluster

# EBS volumes this cluster created that are now unattached
aws ec2 describe-volumes --region us-west-2 \
  --filters "Name=tag:kubernetes.io/cluster/${CLUSTER},Values=owned" \
            "Name=status,Values=available" \
  --query 'Volumes[].[VolumeId,Size,CreateTime]' --output table

# load balancers this cluster created
aws elbv2 describe-load-balancers --region us-west-2 \
  --query 'LoadBalancers[].LoadBalancerArn' --output text \
  | tr '\t' '\n' \
  | while read arn; do
      if aws elbv2 describe-tags --resource-arns "$arn" --region us-west-2 \
         --query "TagDescriptions[].Tags[?Key=='kubernetes.io/cluster/${CLUSTER}']" \
         --output text | grep -q owned; then
        echo "orphaned load balancer: $arn"
      fi
    done
```

Only delete resources that come back tagged as owned by this cluster. Anything untagged, or tagged for a different cluster, belongs to something else and must be left alone.

The idea is: never delete cloud resources based on what looks unattached. Delete based on what belongs to teh cluster in question. Consistent tagging is what makes cleanup safe.

## Rebuilding

The rebuild is easy, because the cluster's desired state lives in Git.

```bash
# 1. rebuild the infrastructure
cd infra/terraform/envs/dev
terraform apply

# 2. point kubectl at the new cluster
aws eks update-kubeconfig --name production-ai-platform-shared-eks-cluster --region us-west-2

# 3. reapply the ArgoCD Applications
kubectl apply -f deploy/argocd/placeholder_app.yaml
kubectl apply -f deploy/argocd/monitoring_app.yaml
```

ArgoCD then reads the repository and rebuilds everything else on its own: the monitoring stack, the placeholder deployment, and any future workloads. Only the Application manifests need to be applied by hand, because they are the bootstrap that points ArgoCD at Git.

## A cheaper alternative to a full teardown

A full destroy and rebuild costs time and loses Prometheus history. For a short break, scaling the node group to zero removes the EC2 cost, which is the expensive part, while leaving the control plane (about $0.10/hour) and the NAT gateway (about $32/month) running.

Set `desired_size = 0` on the node group and apply. Scale it back up when you return.

Use a full teardown for a break of several days or more. Use scale to zero for overnight or a weekend, where the rebuild friction is not worth the savings.
