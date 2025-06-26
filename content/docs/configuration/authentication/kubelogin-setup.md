---
title: kubelogin Setup
weight: 4
---

[kubelogin](https://github.com/int128/kubelogin) is a reliable open source tool
that you can use to authenticate and set up a kubeconfig file for the purpose
of configuring kubectl for use with MKE 4k. Using it, you can add
an authentication client application and audience to your MKE 4k cluster.

To enable the use of kubelogin, edit For security purposes, the
`authentication.kubelogin` parameter in the `mke4.yaml` configuration file is
disabled by default. To enable kubelogin, change the setting to `true`. As a
result, MKE 4k will immediately generate the necessary audience and client
application for kubelogin function.

Because it is so popular with our customers, we have added a way to easily add a client and audience to the cluster that works with the suggested setup in the kubelogin setup guide. We should make sure and provide a link to

kubelogins home page
installation page
setup page
so that users can easily reference each of these.

By default, this will be disabled in order to be secure by default and minimize ways someone could attack the cluster without them knowing about it. Once enabled, MKE4k will generate the audience and client needed for kubelogin to work. If users need to customize the setup in anyway, they will need to create a separate audience and client in their mke config.

How
Once the kubelogin field has been enabled, users can setup kubelogin on their local machine with the following commands

To configure kubelogin:

```
kubectl oidc-login setup \
  --oidc-issuer-url=<cluster's external URL>/dex \
  --oidc-client-id=kubelogin \
  --insecure-skip-tls-verify <-- should be used for testing only
```

This will trigger the authentication flow and open a browser on the user's machine where they will need to enter their credentials

To setup their kubeconfig:

```
kubectl config set-credentials oidc \
--exec-interactive-mode=Never \
--exec-api-version=client.authentication.k8s.io/v1 \
--exec-command=kubectl \
--exec-arg=oidc-login \
--exec-arg=get-token \
--exec-arg=--oidc-issuer-url=<cluster's external address>/dex \
--exec-arg=--oidc-client-id=kubelogin \
--exec-arg=--oidc-extra-scope=email \
--exec-args=--insecure-skip-tls-verify <-- should be used for testing only
```

Users can then use kubectl with this token with

kubectl --user=oidc get pods -A
If the user hasn't authenticated yet or their token is expired, this will open a browser for them to go through the authentication process with.

They can switch kubectl to always use the oidc context with

```
kubectl config set-context --current --user=oidc
```