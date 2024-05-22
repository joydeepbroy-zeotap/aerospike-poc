# aerospike-poc
Aerospike Graph DB and Vector DB POC for Zeotap

## Steps of installation

```python
# Creating the Virtual Machines for the Data nodes with the number of data node instances and the local SSDs to be attached to each data node.
# The system expects `gcloud auth login` is already done and will ssh into the data-nodes to install aerospike db automatically. 
# ➜  aeropsike_scripts ./create_vms.sh
# Usage: ./create_vms.sh <base-instance-name> <local-ssd-count> <number-of-instances>

➜  aeropsike_scripts ./create_vms.sh aerospike-vector-db-poc 4 3
```
