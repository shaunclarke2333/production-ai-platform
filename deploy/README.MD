# deploy/: GitOps Flow

The GitOps flow that let ArgoCD know what to deploy and where to find what it needs to deploy apps to the EKS cluster

## Why it's built this way
- Each app has an application.yaml file, it tells argocd all it needs to know to manage the app lifecycle.
- Kubernetes manifests are stored separately from the ArgoCD configuration, making the deployments easier to organize and maintain.
- ArgoCD continuously compares the git repo to the cluster and keeps them synced
- Manifests must be commited to the main branch before ArgoCD can deploy them, because ArgoCD watches git.
- Auto-sync and self-heal automatically correct configuration drift, ensuring the cluster matches the desired state stored in the repo.

## Depends on
- eks cluster, argocd

## what it references
- Git repo containing the K8S manifests
- path to the manifests: deploy/manifests
- destination EKS cluster
- destination namespace

## How to apply
```bash
kubectl apply -f deploy/argocd/placeholder_app.yaml

```
