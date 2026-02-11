#!/bin/bash
# Fetch secret from Secrets Manager
# Requires jq and aws-cli

SECRET_NAME="vaultedkube/rds/postgres2"
REGION="us-east-1"

echo "Fetching secret $SECRET_NAME from region $REGION..."
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION --query SecretString --output text)

if [ -z "$SECRET_JSON" ]; then
  echo "Error: Could not fetch secret."
  exit 1
fi

DB_USER=$(echo $SECRET_JSON | jq -r .username)
DB_PASSWORD=$(echo $SECRET_JSON | jq -r .password)
DB_HOST=$(echo $SECRET_JSON | jq -r .host)
DB_NAME=$(echo $SECRET_JSON | jq -r .dbname)
DB_PORT=$(echo $SECRET_JSON | jq -r .port)

DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"

echo "Generating kubernetes/backend-k8s/database-secret.yaml..."

cat <<EOF > kubernetes/backend-k8s/database-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secrets
  namespace: final-project
type: Opaque
stringData:
  POSTGRES_DB: "$DB_NAME"
  POSTGRES_USER: "$DB_USER"
  POSTGRES_PASSWORD: "$DB_PASSWORD"
  DATABASE_URL: "$DATABASE_URL"
EOF

echo "Done! You can now apply the secret with: kubectl apply -f kubernetes/backend-k8s/database-secret.yaml"
