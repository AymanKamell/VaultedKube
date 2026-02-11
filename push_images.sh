#!/bin/bash

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 296674251987.dkr.ecr.us-east-1.amazonaws.com

# Tag Images
docker tag vaultedkube-frontend:latest 296674251987.dkr.ecr.us-east-1.amazonaws.com/vaultedkube-frontend:latest
docker tag vaultedkube-backend:latest 296674251987.dkr.ecr.us-east-1.amazonaws.com/vaultedkube-backend:latest

# Push Images
docker push 296674251987.dkr.ecr.us-east-1.amazonaws.com/vaultedkube-frontend:latest
docker push 296674251987.dkr.ecr.us-east-1.amazonaws.com/vaultedkube-backend:latest

echo "Images pushed successfully!"
