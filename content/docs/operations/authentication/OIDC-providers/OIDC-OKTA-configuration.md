---
title: Create OIDC application in Okta
weight: 2
---

1. Select **OIDC - OpenID Connect** for **Sign-in method**.
2. Select **Web Application** for **Application Type**.
3. For **App integration name**, choose a name that you can easily remember.
4. Configure the host for your redirect URLs:
   - Sign-in redirect URIs: `http://{MKE hostname}/login`
   - Sign-out redirect URIs: `http://{MKE hostname}`
5. Click **Save** to generate the `clientSecret` and `clientID` in the `General` table of
the application.
6. Add the generated `clientSecret` and `clientID` values to your MKE configuration file.
7. Run the `mkectl apply` command with your MKE configuration file.

