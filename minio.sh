#!/bin/bash

ROOT_USER=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-user}" | base64 -d)
ROOT_PASSWORD=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-password}" | base64 -d)

# Using curl to call MinIO Admin API to create a new user (thereby generating new access and secret keys)
# Replace the values of MINIO_API_URL, ADMIN_ACCESS_KEY, and ADMIN_SECRET_KEY with actual values for your setup
MINIO_API_URL="http://localhost:9000"
ADMIN_ACCESS_KEY="$ROOT_USER"
ADMIN_SECRET_KEY="$ROOT_PASSWORD"

# Configure MinIO Client (mc)
# Replace MINIO_SERVER_URL, ACCESS_KEY, and SECRET_KEY with your MinIO server details
mc alias set k8s-minio-dev "$MINIO_API_URL" "$ROOT_USER" "$ROOT_PASSWORD"
# create region
REGION="us-east-1"
mc admin config set k8s-minio-dev/ region name="$REGION"
# Create a bucket named 'tap-docs'
BUCKET=customer-profile
mc mb k8s-minio-dev/"$BUCKET" --region "$REGION"


