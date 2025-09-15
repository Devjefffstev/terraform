#!/bin/bash
# Run this command manually to give execute permissions to the script
# chmod +x ./packer/run_packer.sh

set -e

## bring the variables into the script from the packer definition
## read file variables.pkrvar.hcl line by line
while IFS='=' read -r key value; do
  # Remove whitespace and quotes
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | sed 's/[",]//g' | xargs)
  case "$key" in
    managed_image_name) IMAGE_NAME="$value" ;;
    managed_image_resource_group_name) RESOURCE_GROUP="$value" ;;
  esac
done < ./packer/variables.pkrvar.hcl

echo "IMAGE_NAME: $IMAGE_NAME"
echo "RESOURCE_GROUP: $RESOURCE_GROUP"

IMAGE_NAME=$IMAGE_NAME
RESOURCE_GROUP=$RESOURCE_GROUP

# Check if image exists
# You must be logged in to Azure CLI and have the correct subscription selected
if az image show --name "$IMAGE_NAME" --resource-group "$RESOURCE_GROUP" &>/dev/null; then
  echo "Image $IMAGE_NAME already exists. Skipping Packer build."
  exit 0
fi

# Optional: list files for debugging
ls -lathr

# Change to the packer directory
cd ./packer

# Run Packer with force
packer build -force -var-file=variables.pkrvar.hcl nomad.pkr.hcl

