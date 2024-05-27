# VM CREATION README

## Script Overview

This Bash script automates the process of creating Google Cloud VM instances configured to run Aerospike. The script takes user input for instance names, the number of instances, and the number of local SSDs, and then it configures and launches the VMs with the specified parameters.

### Features
- Prompts user for input to configure VMs.
- Ensures at least one local SSD is specified.
- Creates and configures VM instances with Aerospike installed.
- Saves the internal IP addresses of the created instances to a file.

## Prerequisites

Before running this script, ensure you have:

- Google Cloud SDK (`gcloud`) installed and configured.
- Necessary permissions to create VM instances and access related services in your Google Cloud project.
- The Aerospike Enterprise download URL (used in the script).

## Usage

1. **Make the script executable:**

   ```bash
   chmod +x script.sh
    ```
    ```bash
   ./script.sh
    ```

Follow the prompts to enter the required parameters:

- **Base instance name:** Prefix for the instance names.
- **Number of instances:** Total number of VMs to create.
- **Number of local SSDs:** Number of local SSDs per VM (minimum 1).

## Script Details

### User Input

The script prompts the user for three parameters:

- **BASE_INSTANCE_NAME:** The base name for VM instances.
- **NUMBER_OF_INSTANCES:** Number of instances to create.
- **LOCAL_SSD_COUNT:** Number of local SSDs to attach to each instance.

### Instance Configuration

- **Startup Script:** The script creates a `startup-script.sh` file that configures Aerospike on each VM.
- **VM Creation:** The `create_vm` function is used to create each VM instance with the specified configurations, including the local SSDs.
- **Internal IP Addresses:** The internal IP addresses of the created instances are stored in a file named `instance_ips.txt`.

### Aerospike Configuration

- **Download and Install:** The startup script downloads and installs Aerospike.
- **Configuration Files:** The script updates the `features.conf` and `aerospike.conf` files with the necessary configurations.
- **Mount Local SSD:** The script formats and mounts the first local SSD.

## Output

The internal IP addresses of the created instances are saved in a file named `instance_ips.txt`.

## Example

To create 3 VM instances with the base name `aerospike-instance` and 2 local SSDs each:

1. **Run the script:**
   ```bash
   ./script.sh
   ```

    ```bash
      Enter base instance name: aerospike-instance 
      Enter number of instances: 3
      Enter number of local SSDs: 2
    ```

After the script completes, the internal IP addresses of the created instances will be listed in the instance_ips.txt file.




