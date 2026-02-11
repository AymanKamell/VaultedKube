# VaultedKube Deployment

This project contains the Infrastructure as Code (Terraform) and Kubernetes manifests to deploy the VaultedKube application to AWS EKS.

## Infrastructure Updates

We have enhanced the Terraform configuration to include:
- **VPC Endpoints**: For secure communication with ECR, S3, Secrets Manager, and CloudWatch Logs.
- **ECR Repositories**: Managed repositories for storing Frontend and Backend Docker images.
- **RDS Integration**: backend application connects to an AWS RDS PostgreSQL database.

## Kubernetes Updates

- **Deployment Specs**: Updated to use the new ECR image URIs.
- **Backend Configuration**: Updated to connect to the RDS endpoint instead of a local postgres container.
- **Ingress**: Added `ingress-aws.yaml` configured for the AWS Load Balancer Controller (ALB), ensuring the application is accessible from the internet.

## Deployment Steps

### 1. Push Images to ECR
Run the helper script to tag and push your local images to ECR:
```bash
chmod +x push_images.sh
./push_images.sh
```

### 2. Setup Secrets
Establish the `postgres-secrets` in your cluster by fetching the credentials from AWS Secrets Manager.
```bash
chmod +x setup_secrets.sh
./setup_secrets.sh
kubectl apply -f kubernetes/backend-k8s/database-secret.yaml
```

### 3. Deploy to Kubernetes
Apply the backend (creates namespace, secrets, backend, redis):
```bash
kubectl apply -f kubernetes/backend-k8s
```

Apply the frontend (frontend app, service, ingress):
```bash
kubectl apply -f kubernetes/frontend-k8s
```

## Note on Database
The backend is configured to connect to:
`vaultedkube-postgres.cghcymykc28f.us-east-1.rds.amazonaws.com:5432`

Ensure the security groups allow traffic from the EKS nodes to the RDS instance on port 5432.
