#!/bin/bash
# Helper script for applying Terraform changes

set -e

ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
  echo "Error: Invalid environment. Must be dev, staging, or prod"
  exit 1
fi

echo "Applying Terraform changes for $ENVIRONMENT environment..."
cd "environments/$ENVIRONMENT"

terraform apply tfplan

echo "Terraform applied successfully for $ENVIRONMENT"
