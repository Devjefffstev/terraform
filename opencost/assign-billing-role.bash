#!/bin/bash

# Helper to assign the billing EnrollmentReader role to a service principal
# Needs SP name, SP ID, tenant ID, and billing account name variables set

set -euo pipefail

if [[ -z "${SP_NAME}" ]]; then
  echo "SP_NAME is not set"
  exit 1
fi

if [[ -z "${SP_ID}" ]]; then
  echo "SP_ID is not set"
  exit 1
fi

if [[ -z "${TENANT_ID}" ]]; then
  echo "TENANT_ID is not set"
  exit 1
fi

if [[ -z "${BILLING_ACCOUNT_ID}" ]]; then
  echo "BILLING_ACCOUNT_ID is not set"
  exit 1
fi

# Generate a unique name for the assignment.
ROLE_ASSIGNMENT_NAME="$(uuidgen)"

# Get bearer token for talking to API.
ACCESS_TOKEN="$(az account get-access-token --query accessToken -o tsv)"

URL="https://management.azure.com/providers/Microsoft.Billing/billingAccounts/${BILLING_ACCOUNT_ID}/billingRoleAssignments/${ROLE_ASSIGNMENT_NAME}?api-version=2019-10-01-preview"

echo "Creating EnrollmentReader role assignment for SP ${SP_NAME} (${SP_ID}) in billing account ${BILLING_ACCOUNT_ID}"
echo "Role assignment name: ${ROLE_ASSIGNMENT_NAME}"

# This is the role definition ID for EnrollmentReader
ENROLLMENT_READER_ROLE="24f8edb6-1668-4659-b5e2-40bb5f3a7d7e"
RESPONSE="$(curl --silent --show-error -X PUT "${URL}" \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-H "Content-type: application/json" \
-d "{
  \"properties\": {
    \"principalId\": \"${SP_ID}\",
    \"principalTenantId\": \"${TENANT_ID}\",
    \"roleDefinitionId\": \"/providers/Microsoft.Billing/billingAccounts/${BILLING_ACCOUNT_ID}/billingRoleDefinitions/${ENROLLMENT_READER_ROLE}\"
  }
}")"

echo "Response: ${RESPONSE}"