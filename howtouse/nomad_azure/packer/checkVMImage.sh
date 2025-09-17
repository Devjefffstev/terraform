#!/bin/bash

RESOURCE_GROUP="rg-nomad"
GALLERY_NAME="vmss_nomad_comp_gallery"
IMAGE_DEFINITION="nomad"
IMAGE_VERSION="0.0.1"
TIMEOUT=3 # Timeout in seconds

echo "Waiting for image version $IMAGE_VERSION to be created in resource group $RESOURCE_GROUP, gallery $GALLERY_NAME, and image definition $IMAGE_DEFINITION..."

# Wait for the image version to exist
RESULT=$(az sig image-version wait \
  --resource-group "$RESOURCE_GROUP" \
  --gallery-name "$GALLERY_NAME" \
  --gallery-image-definition "$IMAGE_DEFINITION" \
  --gallery-image-version "$IMAGE_VERSION" \
  --created \
  --timeout "$TIMEOUT" \
  --exists -o json)

# Check the result
if [ "$RESULT" == "{}" ]; then
  echo "Timeout reached, and the image version $IMAGE_VERSION does not exist."
  exit 1
elif [ $? -eq 0 ]; then
  echo "Image version $IMAGE_VERSION has been successfully created!"
else
  echo "Image version $IMAGE_VERSION has been successfully created!"
fi