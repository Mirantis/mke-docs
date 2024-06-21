---
title: Monitoring
weight: 4
---

The MKE 4 monitoring setup is based on the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack),
offering a comprehensive solution for collecting, storing, and visualizing metrics.

## Monitoring tools

Detail for the MKE 4 monitor tools is provided in the following table:

| Monitoring tool    | Default state | Configuration key          | Description                                                                           |
|------------|---------------|----------------------------|---------------------------------------------------------------------------------------|
| Grafana    | enabled       | `monitoring.enableGrafana` | Provides a web interface for viewing metrics and logs collected by Prometheus         |
| Prometheus | enabled       | -                          | Collects and stores metrics                                                           |
| Opscare    | disabled      | `monitoring.enableOpscare` | (Under development) Supplies additional monitoring capabilities, such as Alertmanager |

## Grafana

[Grafana](https://grafana.com/) is an open-source monitoring platform that provides a rich set of tools for visualizing time-series data. It
includes a variety of graph types and dashboards.

Grafana is enabled in MKE by default and may be disabled through the MKE configuration file:

```yaml
monitoring:
  enableGrafana: true
```

To access the Grafana dashboard:

1. Run the following command to `port-forward` Grafana:

    ```bash
    kubectl --namespace mke port-forward svc/monitoring-grafana 3000:80
    ```

2. Go to [http://localhost:3000](http://localhost:3000).

## Prometheus

[Prometheus](https://prometheus.io/) is an open-source monitoring and alerting
toolkit that is designed for reliability and scalability. It collects and stores metrics
as time series data, providing powerful query capabilities and a flexible alerting system.

To access the Prometheus dashboard:

1. Run the following command to `port-forward` Prometheus:

    ```bash
    kubectl --namespace mke port-forward svc/prometheus-operated 9090
    ```

2. Go to [http://localhost:9090](http://localhost:9090).

## Opscare (Under development)

[Mirantis OpsCare](https://www.mirantis.com/resources/opscare-datasheet/) is
an advanced monitoring and alerting solution. Once it is integrated, Mirantis Opscare will enhance the monitoring
capabilities of MKE 4 by incorporating additional tools and features, such as
[Prometheus Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/).

Disabled by default, you can enable Mirantis Opscare through the MKE configuration file.

```yaml
monitoring:
  enableOpscare: true
```
