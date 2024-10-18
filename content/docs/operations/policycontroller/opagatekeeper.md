---
title: OPA Gatekeeper
weight: 2
---

MKE 4 supports the use of OPA Gatekeeper for purposes of policy control.

[Open Policy Agent (OPA)](https://open-policy-agent.github.io/gatekeeper/website/docs/) is an open source policy engine that facilitates policy-based control for cloud native environments. OPA introduces a high-level declarative language called Rego that decouples policy decisions from enforcement.

The OPA Constraint Framework introduces the following primary resources:

- Constraint templates - OPA policy definitions, written in Rego.
- Constraints - the application of a constraint template to a given set of objects.

Gatekeeper uses the Kubernetes API to integrate OPA into Kubernetes. Policies are defined in the form of
Kubernetes CustomResourceDefinitions (CRDs) and are enforced with custom admission controller webhooks.
These CRDs define constraint templates and constraints on the API server. Any time a request to create, delete, or
update a resource is sent to the Kubernetes cluster API server, Gatekeeper validates that resource against the
predefined policies. Gatekeeper also audits preexisting resource constraint violations against newly defined
policies.

Using OPA Gatekeeper, you can enforce a wide range of policies against your Kubernetes cluster. Policy examples include:

- Container images can only be pulled from a set of whitelisted repositories.
- New resources must be appropriately labeled.
- Deployments must specify a minimum number of replicas.

## Configuration

To configure OPA Gatekeeper in MKE, set the following fields in the MKE 4 configuration file:

```yaml
spec:
  policyController:
    opaGatekeeper:
      enabled: true
      exemptNamespaces:
      - <Namespace1>
      - <Namespace2>
```

The `exemptNamespaces` field lists the namespaces that are exempt from policy enforcement.
The following namespaces are added by default, and thus cannot be removed:

- `mke`
- `kube-system`
- `kube-public`
- `kube-node-lease`
- `k0s-system`
- `k0s-autopilot`
- `flux-system`
- `blueprint-system`

## Migration from MKE 3

If OPA Gatekeeper is enabled in MKE 3, the templates, constraints and list of
namespaces exempted from policy control are retained through the migration process.

## Test OPA Gatekeeper

Before proceeding, make sure that OPA Gatekeeper is enabled and the configuration is applied to the cluster.

To check if the OPA Gatekeeper pods have entered the `Running` state, run:

```bash
kubectl get pod -n mke
```

Example output:

```bash
NAME                                             READY   STATUS    RESTARTS      AGE
gatekeeper-audit-56d958d955-v6d7t                1/1     Running   2 (54s ago)   61s
gatekeeper-controller-manager-79c4f4bfc7-8m9nq   1/1     Running   0             61s
gatekeeper-controller-manager-79c4f4bfc7-n66mj   1/1     Running   0             61s
gatekeeper-controller-manager-79c4f4bfc7-v8lx7   1/1     Running   0             61s
...
```

To create constraint templates and constraints from the open source [Gatekeeper library](https://github.com/open-policy-agent/gatekeeper-library), run:

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/allow-privilege-escalation/template.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/allow-privilege-escalation/samples/psp-allow-privilege-escalation-container/constraint.yaml
```

To create pods that are disallowed by the newly created policies, run:

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/allow-privilege-escalation/samples/psp-allow-privilege-escalation-container/example_disallowed.yaml
```

Example output:

```bash
Error from server (Forbidden): error when creating "https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/allow-privilege-escalation/samples/psp-allow-privilege-escalation-container/example_disallowed.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [psp-allow-privilege-escalation-container] Privilege escalation container is not allowed: nginx
```

## MKE version comparison

| MKE 3                                                              | MKE 4                                           |
|--------------------------------------------------------------------|-------------------------------------------------|
| [cluster_config.policy_enforcement.gatekeeper.enabled]             | policyController.opaGatekeeper.enabled          |
| [cluster_config.policy_enforcement.gatekeeper.excluded_namespaces] | policyController.opaGatekeeper.exemptNamespaces |
