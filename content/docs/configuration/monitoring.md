---
title: Monitoring
weight: 4
---

The MKE 4 monitoring setup is based on the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack),
offering a comprehensive solution for collecting, storing, and visualizing metrics.

## Monitoring tools

Detail for the MKE 4 monitor tools is provided in the following table:

| Monitoring tool | Default state | Configuration key           | Description                                                                           |
|-----------------|---------------|-----------------------------|---------------------------------------------------------------------------------------|
| Prometheus      | enabled       | -                           | Collects and stores metrics                                                           |
| Grafana         | enabled       | `monitoring.enableGrafana`  | Provides a web interface for viewing metrics and logs collected by Prometheus         |
| cAdvisor        | disabled      | `monitoring.enableCAdvisor` | Provides additional container level metrics                                           |
| OpsCare         | disabled      | `monitoring.enableOpscare`  | (Under development) Supplies additional monitoring capabilities, such as Alertmanager |

## Prometheus

[Prometheus](https://prometheus.io/) is an open-source monitoring and alerting
toolkit, designed for reliability and scalability, that collects and stores metrics
as time series data. It offers powerful query capabilities and a flexible alerting system.

The Prometheus API is available at `https://<mke4_url>/prometheus/`

To access the Prometheus dashboard:

1. Port forward Prometheus:

    ```bash
    kubectl --namespace mke port-forward svc/prometheus-operated 9090
    ```

2. Navigate to `http://localhost:9090`.

## Grafana

[Grafana](https://grafana.com/) is an open-source monitoring platform that provides a rich set of tools for visualizing time-series data. It
includes a variety of graph types and dashboards.

Grafana is enabled in MKE by default and may be disabled through the MKE configuration file:

```yaml
monitoring:
  enableGrafana: true
```

To access the Grafana dashboard:

1. Obtain the `admin` user password for the Grafana dashboard from the `monitoring-grafana` secret in the `mke` namespace.

   ```bash
   kubectl get secret monitoring-grafana -n mke -o jsonpath="{.data.admin-password}" | base64 --decode
   ```

2. Port forward Grafana:

    ```bash
    kubectl --namespace mke port-forward svc/monitoring-grafana 3000:80
    ```

3. Navigate to `http://localhost:3000` to access the **Welcome to Grafana** login page.

4. Enter the default username **admin** into the **Email or username** field and type the password you retrieved from the `monitoring-grafana` secret into the **Password** field.

5. Click **Log In**.
   
## cAdvisor

[cAdvisor](https://github.com/google/cadvisor) is an open-source tool that collects, aggregates, processes, 
and exports information in reference to running containers.

cAdvisor is disabled in MKE by default. You can enable the tool through the MKE configuration file:

```yaml
monitoring:
  enableCAdvisor: true
```

## OpsCare (Under development)

[Mirantis OpsCare](https://www.mirantis.com/resources/opscare-datasheet/) is
an advanced monitoring and alerting solution. Once it is integrated, Mirantis OpsCare will enhance the monitoring
capabilities of MKE 4 by incorporating additional tools and features, such as
[Prometheus Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/).

Disabled by default, you can enable Mirantis OpsCare through the MKE configuration file.

```yaml
monitoring:
  enableOpscare: true
```
