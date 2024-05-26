#!/bin/bash

# Check if the number of local SSDs is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <number-of-local-SSDs>"
  exit 1
fi

# File containing instance names and their internal IPs
IP_FILE="instance_ips.txt"

# GCP project and zone details
PROJECT="zeotap-aerospike-poc"
ZONE="europe-west1-b"

# Number of local SSDs
LOCAL_SSD_COUNT=$1

# Arrays to store instance names and IPs
instance_names=()
instance_ips=()

# Read the file and store the instance names and IPs in arrays
while IFS=' ' read -r instance_name internal_ip; do
  instance_names+=("$instance_name")
  instance_ips+=("$internal_ip")
done < "$IP_FILE"

# Generate the MESH-SEED-ADDRESS-PORT string
mesh_seed_address_port=""
for i in "${!instance_ips[@]}"; do
  if [ $i -eq 0 ]; then
    mesh_seed_address_port+=$'\t'"mesh-seed-address-port ${instance_ips[$i]} 3002\n"
  else
    mesh_seed_address_port+="                mesh-seed-address-port ${instance_ips[$i]} 3002\n"
  fi
done

# Generate the STORAGE_DEVICES string
storage_devices=""
for ((i=2; i<LOCAL_SSD_COUNT+1; i++)); do
  storage_devices+="                device /dev/nvme0n$i\n"
done

# Function to update the aerospike.conf file on a VM
update_aerospike_conf() {
  local instance_name=$1
  local internal_ip=$2

  # Command to update the aerospike.conf file
  gcloud compute ssh --zone "$ZONE" "$instance_name" --project "$PROJECT" --command "
  sudo sed -i 's/access-address .*/access-address $internal_ip/' /etc/aerospike/aerospike.conf
  sudo sed -i '/mode mesh/a $mesh_seed_address_port' /etc/aerospike/aerospike.conf
  sudo sed -i 's|\$STORAGE_DEVICES|$storage_devices|' /etc/aerospike/aerospike.conf
  sudo sed -i '/$MESH-SEED-ADDRESS-PORT/,/^$/d' /etc/aerospike/aerospike.conf
  "

  echo "Updated aerospike.conf on $instance_name with IP $internal_ip"
}

# Loop through the instances and update the aerospike.conf file
for ((i=0; i<${#instance_names[@]}; i++)); do
  update_aerospike_conf "${instance_names[$i]}" "${instance_ips[$i]}"
done

echo "aerospike.conf update complete for all instances."
