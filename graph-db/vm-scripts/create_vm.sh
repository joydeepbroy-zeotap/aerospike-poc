#!/bin/bash

# Check if the required parameters are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <instance-name> <local-ssd-count>"
  exit 1
fi

INSTANCE_NAME=$1
LOCAL_SSD_COUNT=$2

# Construct the local SSD arguments
LOCAL_SSD_ARGS=""
for ((i = 1; i <= LOCAL_SSD_COUNT; i++)); do
  LOCAL_SSD_ARGS+=" --local-ssd=interface=NVME"
done

gcloud compute instances create "$INSTANCE_NAME" \
  --project=zeotap-aerospike-poc \
  --zone=europe-west1-b \
  --machine-type=n1-highmem-8 \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --maintenance-policy=MIGRATE \
  --provisioning-model=STANDARD \
  --local-ssd-recovery-timeout=1 \
  --service-account=343975139575-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --tags=aerospike-data-node-poc-eu \
  --create-disk=auto-delete=yes,boot=yes,device-name="$INSTANCE_NAME",image=projects/debian-cloud/global/images/debian-10-buster-v20240417,mode=rw,size=10,type=projects/zeotap-aerospike-poc/zones/europe-west1-b/diskTypes/pd-standard \
  $LOCAL_SSD_ARGS \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels=goog-ec-src=vm_add-gcloud \
  --reservation-affinity=any
