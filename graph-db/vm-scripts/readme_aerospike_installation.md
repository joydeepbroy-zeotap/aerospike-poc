# Aerospike Installation Script Overview

This Bash script automates the process of updating the `aerospike.conf` configuration file on a set of Google Cloud VM instances running Aerospike. The script reads instance names and their internal IPs from a file, constructs necessary configuration strings, and updates the configuration file on each VM.

## Features

- Reads instance names and internal IPs from a file.
- Constructs `mesh-seed-address-port` and `STORAGE_DEVICES` strings.
- Uses SSH to update the `aerospike.conf` file on each VM with the necessary configurations.

## Prerequisites

Before running this script, ensure you have:

- Google Cloud SDK (`gcloud`) installed and configured.
- Necessary permissions to SSH into your Google Cloud VM instances and modify files.
- A file named `instance_ips.txt` containing the instance names and their internal IPs, separated by a space.

## Usage

### Make the script executable:

```bash
chmod +x script.sh
```

```bash
    ./script.sh <number-of-local-SSDs>
```

Follow the prompts to enter the required parameters:

- **number-of-local-SSDs**: Number of local SSDs per VM (minimum 1).

## Script Details

### User Input

The script takes one parameter from the command line:

- **LOCAL_SSD_COUNT**: Number of local SSDs to attach to each instance.

### Instance Configuration

- **File Reading**: The script reads instance names and their internal IPs from the `instance_ips.txt` file.
- **String Generation**: The script generates strings for `mesh-seed-address-port` and `STORAGE_DEVICES` based on the input and configuration.

### Configuration Update

- **Startup Script**: The script creates a startup script that configures Aerospike on each VM.
- **VM Creation**: The `update_aerospike_conf` function updates the `aerospike.conf` file on each VM instance with the specified configurations, including the local SSDs.

### Output

The script updates the `aerospike.conf` file on each VM instance, reflecting the internal IP addresses and storage devices.

## Example

To update the configuration on your VM instances with 2 local SSDs each:

### Run the script:

```bash
./script.sh 2
```


## Expected Output

The script will read the `instance_ips.txt` file and update the `aerospike.conf` file on each VM instance. The completion message will be:

```plaintext
aerospike.conf update complete for all instances.
```

Notes
Ensure the instance_ips.txt file is correctly formatted with instance names and internal IPs.
Modify the script as needed to match your specific requirements and environment.
