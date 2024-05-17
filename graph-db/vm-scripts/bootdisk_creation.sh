#!/bin/bash

# Check if the required parameters are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <bearer-token> <disk-name>"
  exit 1
fi

BEARER_TOKEN=$1
DISK_NAME=$2

curl -X POST \
  https://compute.googleapis.com/compute/v1/projects/zeotap-aerospike-poc/zones/europe-west1-b/disks \
  -H "Authorization: Bearer $BEARER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$DISK_NAME\",
    \"resourcePolicies\": [
      \"projects/zeotap-aerospike-poc/regions/europe-west1/resourcePolicies/default-schedule-1\"
    ],
    \"sizeGb\": \"200\",
    \"type\": \"projects/zeotap-aerospike-poc/zones/europe-west1-b/diskTypes/pd-standard\",
    \"zone\": \"projects/zeotap-aerospike-poc/zones/europe-west1-b\"
  }"
