#!/bin/bash

# Check if AUTH_TOKEN and VM_NAME are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 AUTH_TOKEN VM_NAME"
    exit 1
fi

AUTH_TOKEN=$1
VM_NAME=$2

# Execute the curl command with provided AUTH_TOKEN and VM_NAME
curl -X DELETE \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  "https://compute.googleapis.com/compute/v1/projects/zeotap-aerospike-poc/zones/europe-west1-b/instances/$VM_NAME"
