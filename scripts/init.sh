#!/bin/bash
# Helper script for initializing Terraform in different environments

set -e

ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
  echo "Error: Invalid environment. Must be dev, staging, or prod"
  exit 1
fi

echo "Initializing Terraform for $ENVIRONMENT environment..."
cd "environments/$ENVIRONMENT"

terraform init
terraform validate

echo "Terraform initialized successfully for $ENVIRONMENT"
