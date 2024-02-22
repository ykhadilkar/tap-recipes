# How to deploy TAP in 5 mins 

## Create cluster
- Create TKGs Cluster 
- Control Plane size 2XL 
- Minimum 2 worker nodes

Control Plane Config
![TMC Controlplane Config](/tmc-control-plane-config.png)

Use following config for default volumes
![Configure default vols](/configure-default-vols.png)

Node Pool Config
![node pool config](/node-pool-config.png)

## Install TAP
Login to TMC via console.cloud.vmware.com

Goto Catalog -> Select Single Cluster TAP deployment

Sample Profile Configuration
![TAP Profile](/configure-profile.png)

If you dont have registry, you will have to create one. Bellow is sample config
![Harbor secret](/create-secret.png)

Click Next, Accept the terms. 

Install TAP. DONE!

## Customize TAP Installation 