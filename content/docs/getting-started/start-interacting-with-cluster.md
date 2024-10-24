---
title: Start interacting with the cluster
weight: 4
---

To start interacting with the cluster, use `kubectl` with the `mke` context.
Though to do that, you need to specify the configuration. Use `mkectl` to output
the kubeconfig of the cluster to `~/mke/.mke.kubeconfig`.

You can apply `.mke.kubeconfig` using any one of the following methods:

* Set the `KUBECONFIG` environment variable to point to `~/.mke/mke.kubeconfig`:

  ```shell
  export KUBECONFIG=~/.mke/<cluster name>.kubeconfig
  ```

* Append the contents to the default kubeconfig:

  ```shell
  cat ~/.mke/mke.kubeconfig >> ~/.kube/config
  ```

* Specify the kubeconfig as a command argument:

  ```shell
  kubectl --kubeconfig ~/.mke/mke.kubeconfig
  ```

Example output:

```bash
$ kubectl --context mke get nodes

NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    <none>          2d    v1.29.3+k0s
node2   Ready    control-plane   2d    v1.29.3+k0s
```

To modify the cluster configuration, edit the YAML configuration file and
rerun the `apply` command:

```shell
mkectl apply -f mke.yaml
```
