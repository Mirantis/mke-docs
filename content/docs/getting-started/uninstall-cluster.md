---
title: Uninstall a cluster
weight: 6
---

1. Destroy the last MKE cluster you created using the `reset` command:

   ```shell
   mkectl reset -f mke4.yaml
   ```

2. Confirm cluster deletion.

   Example output:
   
   ```shell
   INF Reset Blueprint Operator resources
   INF Resetting Blueprint
   INF Uninstalling Blueprint Operator
   INF Deleting 16 objects
   k0sctl v0.19.4 Copyright 2023, k0sctl authors.
   Anonymized telemetry of usage will be sent to the authors.
   By continuing to use k0sctl you agree to these terms:
   https://k0sproject.io/licenses/eula
   INFO ==> Running phase: Connect to hosts 
   INFO [ssh] 54.153.41.129:22: connected            
   INFO [ssh] 54.215.249.216:22: connected           
   INFO ==> Running phase: Detect host operating systems 
   INFO [ssh] 54.153.41.129:22: is running Ubuntu 22.04.5 LTS 
   INFO [ssh] 54.215.249.216:22: is running Ubuntu 22.04.5 LTS 
   INFO ==> Running phase: Acquire exclusive host lock 
   INFO ==> Running phase: Prepare hosts    
   INFO ==> Running phase: Gather host facts 
   INFO [ssh] 54.153.41.129:22: using ip-172-31-35-203.us-west-1.compute.internal as hostname 
   INFO [ssh] 54.215.249.216:22: using ip-172-31-134-35.us-west-1.compute.internal as hostname 
   INFO [ssh] 54.153.41.129:22: discovered ens5 as private interface 
   INFO [ssh] 54.215.249.216:22: discovered ens5 as private interface 
   INFO [ssh] 54.153.41.129:22: discovered 172.31.35.203 as private address 
   INFO [ssh] 54.215.249.216:22: discovered 172.31.134.35 as private address 
   INFO ==> Running phase: Gather k0s facts 
   INFO [ssh] 54.215.249.216:22: found existing configuration 
   INFO [ssh] 54.215.249.216:22: is running k0s controller+worker version v1.31.2+k0s.0 
   WARN [ssh] 54.215.249.216:22: the controller+worker node will not schedule regular workloads without toleration for node-role.kubernetes.io/master:NoSchedule unless 'noTaints: true' is set 
   INFO [ssh] 54.215.249.216:22: listing etcd members 
   INFO [ssh] 54.153.41.129:22: is running k0s worker version v1.31.2+k0s.0 
   INFO [ssh] 54.215.249.216:22: checking if worker ip-172-31-35-203.us-west-1.compute.internal has joined 
   INFO ==> Running phase: Reset workers    
   INFO [ssh] 54.153.41.129:22: reset                
   INFO ==> Running phase: Reset controllers 
   INFO [ssh] 54.215.249.216:22: reset               
   INFO ==> Running phase: Reset leader     
   INFO [ssh] 54.215.249.216:22: reset               
   INFO ==> Running phase: Reload service manager 
   INFO [ssh] 54.153.41.129:22: reloading service manager 
   INFO [ssh] 54.215.249.216:22: reloading service manager 
   INFO ==> Running phase: Release exclusive host lock 
   INFO ==> Running phase: Disconnect from hosts 
   INFO ==> Finished in 26s 
   ```
