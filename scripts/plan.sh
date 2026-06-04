#!/bin/bash
# Helper script for planning Terraform changes

set -e

ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
  echo "Error: Invalid environment. Must be dev, staging, or prod"
  exit 1
fi

echo "Planning Terraform changes for $ENVIRONMENT environment..."
cd "environments/$ENVIRONMENT"

terraform init

terraform plan -out="tfplan"

echo "Plan saved to tfplan"
