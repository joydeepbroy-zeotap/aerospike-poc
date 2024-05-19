# Steps to delete a VM using the `delete_vm.sh` script

You can create a shell script file (let's name it `delete_vm.sh`) with the following content:

```bash
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

```
# Execute chmod +x delete_vm.sh

# Execute ./delete_vm.sh YOUR_ACCESS_TOKEN VM_NAME


#Steps to fetch the auth token 

#Install the Google Cloud SDK: If you haven't already installed it, you can download and install the Google Cloud SDK from here.

#Authenticate with Google Cloud: Run the following command and follow the instructions to authenticate with your Google Cloud account:


```
gcloud auth login
Get Access Token: Once authenticated, you can use the following command to get an access token:
```

```
gcloud auth print-access-token
This command will print the access token to the console, which you can then use in your curl command.
```
