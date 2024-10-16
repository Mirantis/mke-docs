---
title: Setting up Okta as an OIDC provider
weight: 1
---

To configure an Okta application to serve as your [OIDC authentication](../../../../docs/configuration/authentication/oidc) provider for MKE 4:

1. Navigate to (Okta)[https://www.okta.com/] and sign in to your account dashboard.
2. Select **OIDC - OpenID Connect** for **Sign-in method**.
3. Select **Web Application** for **Application Type**.
4. For **App integration name**, choose a name that you can easily remember.
5. Configure the host for your redirect URLs:
   - Sign-in redirect URIs: `http://{MKE hostname}/login`
   - Sign-out redirect URIs: `http://{MKE hostname}`
6. Click **Save** to generate the `clientSecret` and `clientID` in the `General` table of the application.
7. Add the generated `clientSecret` and `clientID` values to your MKE configuration file.
8. Run the `mkectl apply` command with your MKE configuration file.

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Select **Log in with SAML**. This will redirect you to the Okta
   login page for your application.
3. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
