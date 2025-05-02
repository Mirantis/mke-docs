---
title: Enhancements
weight: 2
---

Detail on the enhancements introduced in MKE 4k 4.1.0 includes:

<!--- [BOP-891] -->

- Augmented the error message the user receives when an upgrade
  failure occurs due the presence of a previous configuration file in the
  ``~/.mke/mke.kubeconf`` directory.

<!--- [BOP-1654] -->

- Certificate data is now obscured in the MKE web UI once it has
  been saved.

<!--- [BOP-1629] -->

- Addition of a static pre-login licensing message that displays
  after the first login and perpetually for unlicensed users.

<!--- [BOP-1532] -->

- Password restrictions integrated in the MKE web UI for length and
  use of white space.

<!--- [BOP-1021] -->

- Telemetry data now contains the MKE 4 version number.

  Example:

  ```
  "app": {
       "name": "m***",
       "version": "v4.1.0"
     },
  ```

<!--- [BOP-1021] -->

- Telemetry data now contains the external IP address.

  Example:

  ```
  "direct": true,
     "ip": "3***.2***.5***.1***",
     "library": {
       "name": "analytics-go",
       "version": "3.0.0"
     }
  ```

<!--- [BOP-1702] -->

- Telemetry data now contains metrics for individual nodes and
  Kubernetes resource usage.

<!--- [BOP-1581] -->

- Removed the redundant namespace selector under ``Namesaces > New``
  in the MKE web UI.

<!--- [BOP-1513] -->

- Users are now required to enter their current password as part
  of the process of setting a new one.