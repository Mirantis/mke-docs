---
title: Telemetry
weight: 4
---

You can set MKE to automatically record and transmit data to Mirantis through
an encrypted channel for monitoring and analysis purposes. This data helps the
Mirantis Customer Success Organization to better understand how customers
use MKE. It also provides product usage statistics, which is key feedback that
helps product teams in their efforts to enhance Mirantis products and
services.

{{< callout type="info" >}}
    The MKE 4 telemetry enablement setting is automatically applied to the k0s configuration. 
{{< /callout >}}

{{< callout type="info" >}}
   Telemetry is automatically enabled for MKE 4 clusters that are running
   without a license, with a license that has expired, or with an invalid
   license. In all of such scenarios, you can only disable
   telemetry once a valid license has been applied to the cluster.
{{< /callout >}}

## Enable telemetry through the MKE CLI

1. Access the MKE configuration file.
2. Set the `telemetry.enabled` field to `true`.

   ```yaml
   spec:
     tracking:
       enabled: true
   ```

3. Run the  `mkectl apply` command to apply the new settings.

After a few moments, the change will reconcile in the configuration. From this point onward,
MKE will transmit key usage data to Mirantis by way of a secure Segment endpoint.

## Enable telemetry through the MKE web UI

1. Log in to the MKE web UI as an administrator.

2. Click **Admin Settings** to display the available options.

3. Click **Telemetry** to call the **Telemetry** screen.

4. Click **Enable Telemetry**.

5. Click **Save**.
