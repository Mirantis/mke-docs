---
title: Set your license in the configuration
weight: 3
---

{{< callout type="warning" >}}

You must have a valid license to lawfully run MKE 4k. For more
information, refer to [Mirantis Agreements and Terms](https://legal.mirantis.com/).

{{< /callout >}}

To ensure that your MKE 4k cluster is licensed upon installation:

1. Insert the license into ``spec.license.token`` in the `mke4.yaml`
   configuration file:

    ```yaml
    spec:
      license:
        token: <your-license-file>
    ```

2. Apply the license:

   ```commandline
   mkectl apply
   ```

3. Check the license status:

   ```commandline
   kubectl -n mke get mkeconfig mke -ojsonpath="{.status.licenseStatus}" | jq 
   ```

   Example output:

   ```json
   {
     "expiration": "2027-10-10T07:00:00Z",
     "licenseType": "Offline",
     "maxEngines": 10,
     "scanningEnabled": true,
     "subject": "example",
     "tier": "Production"
   }
   ```


