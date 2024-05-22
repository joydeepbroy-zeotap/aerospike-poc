#!/bin/bash

# Check if the required parameters are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <base-instance-name> <local-ssd-count> <number-of-instances>"
  exit 1
fi

BASE_INSTANCE_NAME=$1
LOCAL_SSD_COUNT=$2
NUMBER_OF_INSTANCES=$3

# Ensure at least one local SSD is specified
if [ "$LOCAL_SSD_COUNT" -lt 1 ]; then
  echo "At least one local SSD is required."
  exit 1
fi

# File to store instance names and their internal IPs
IP_FILE="instance_ips.txt"

# Clear the IP file if it exists
> $IP_FILE

# Create the startup script
STARTUP_SCRIPT="startup-script.sh"

cat << 'EOF' > $STARTUP_SCRIPT
#!/bin/bash
sudo su - <<'EOSU'
# Update and install Aerospike
apt-get update
wget -O aerospike-server.tgz https://enterprise.aerospike.com/enterprise/download/server/7.0.0/artifact/ubuntu22_amd64
tar -zxvf aerospike-server.tgz
cd aerospike-server-enterprise*
./asinstall

# Replace the feature.conf file
cat << 'EOCONF' > /etc/aerospike/features.conf
# generated 2023-12-08 18:55:29

feature-key-version              2
serial-number                    689958957

account-name                     Aerospike
account-ID                       8_Node_EE_60_Day_Trial

valid-until-date                 2024-06-22

asdb-change-notification         true
asdb-cluster-nodes-limit         8
asdb-compression                 true
asdb-encryption-at-rest          true
asdb-flash-index                 true
asdb-ldap                        true
asdb-pmem                        true
asdb-rack-aware                  true
asdb-secrets                     true
asdb-strong-consistency          true
asdb-vault                       true
asdb-xdr                         true
database-recovery                true
elasticsearch-connector          true
graph-service                    true
mesg-jms-connector               true
mesg-kafka-connector             true
presto-connector                 true
pulsar-connector                 true
spark-connector                  true

----- SIGNATURE ------------------------------------------------
MEUCIBysM4P/9y8TXIDlTCt1uyJopC1jvLRXhmoamDbkI9LPAiEAs6XrFt/Mm79l
rQNG66+1ImdmDecY3kQL1AV2MiZtqkck
----- END OF SIGNATURE -----------------------------------------
EOCONF

# Replace the aerospike.conf file
cat << 'AEROSPIKECONFIG' > /etc/aerospike/aerospike.conf
service {
        proto-fd-max 15000
        cluster-name zeotap
#        feature-key-file /etc/aerospike/trial-features.conf
}

logging {
    file /var/log/aerospike.log {
        context any info
    }
}

network {
        service {
                address any
                port 3000
                access-address 10.132.0.23
        }

        heartbeat {
                mode mesh
                port 3002

                mesh-seed-address-port 10.132.0.23 3002
                mesh-seed-address-port 10.132.0.22 3002
                mesh-seed-address-port 10.132.0.21 3002
                # To use unicast-mesh heartbeats, remove the 3 lines above, and see
                # aerospike_mesh.conf for alternative.

                interval 150
                timeout 10
        }

        fabric {
                port 3001
        }

#       info {
#               port 3003
#       }
}

namespace idu {
        replication-factor 2
        transaction-pending-limit 0
        #default-ttl 0
        partition-tree-sprigs 4096
        index-type flash {
                mount /mnt/nvme_drive/nvme0n1
                mounts-budget 5G
        }
        storage-engine device {
                device /dev/nvme0n2
                device /dev/nvme0n3
                device /dev/nvme0n4
                write-block-size 128K
        }
}
AEROSPIKECONFIG

# Format and mount the first local SSD
mkfs.ext4 /dev/nvme0n1
mkdir -p /mnt/nvme_drive/nvme0n1
mount /dev/nvme0n1 /mnt/nvme_drive/nvme0n1

EOSU
EOF

# Function to create a single VM
create_vm() {
  INSTANCE_NAME=$1
  LOCAL_SSD_COUNT=$2

  # Construct the local SSD arguments
  LOCAL_SSD_ARGS=""
  for ((i = 1; i <= LOCAL_SSD_COUNT; i++)); do
    LOCAL_SSD_ARGS+=" --local-ssd=interface=NVME"
  done

  # Create the VM
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
    --create-disk=auto-delete=yes,boot=yes,device-name="$INSTANCE_NAME",image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240519,mode=rw,size=10,type=projects/zeotap-aerospike-poc/zones/europe-west1-b/diskTypes/pd-standard \
    $LOCAL_SSD_ARGS \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
    --metadata-from-file startup-script=$STARTUP_SCRIPT

  # Capture the internal IP address of the created VM
  INTERNAL_IP=$(gcloud compute instances describe "$INSTANCE_NAME" \
    --zone=europe-west1-b --project zeotap-aerospike-poc \
    --format='get(networkInterfaces[0].networkIP)')

  # Write the instance name and internal IP to the file
  echo "$INSTANCE_NAME $INTERNAL_IP" >> $IP_FILE
}

# Loop to create the specified number of VMs
for ((n = 1; n <= NUMBER_OF_INSTANCES; n++)); do
  INSTANCE_NAME="${BASE_INSTANCE_NAME}-${n}"
  create_vm "$INSTANCE_NAME" "$LOCAL_SSD_COUNT"
done

echo "Instance creation complete. Internal IP addresses saved to $IP_FILE."
