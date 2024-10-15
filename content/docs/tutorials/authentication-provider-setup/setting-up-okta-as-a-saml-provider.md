---
title: Setting up Okta as a SAML provider
weight: 2
---

To configure an Okta application to serve as your [SAML authentication](../../../../docs/configuration/authentication/saml) provider for MKE 4:

1. Navigate to (Okta)[https://www.okta.com/] and sign in to your account dashboard.
2. Select **SAML 2.0** for **Sign-in method**.
3. Enter an **App name** that is easy to remember.
4. Configure the host for your redirect URLs:
   - Single sign-on URL: `http://{MKE hostname}/callback`
   - Audience URI (SP Entity ID): `http://{MKE hostname}/callback`
   - Attribute statements:
     - Name: email
       <br>Value: user.email
     - Name: name
       <br>Value: user.login
5. Click **Save**.
6. Click **Finish**.
7. Navigate to the **Assignments** tab:
8. Click **Assign** -> **Assign to people**.
9. Click the blue **Assign** button that corresponds to the account you want to use for authentication.

   - Okta generates the `ssoURL` and certificate under the `Sign On` tab.
   - The `ssoURL` is the MetadataURL with the final metadata removed from the path.

10. Download the certificate to the system from which you will run mkectl:
    a. Navigate to the SAML **Signing Certificates** section.
    b. Click **Actions** for the active certificate and initiate the download.
11. Run the `mkectl apply` command with your MKE configuration file.

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Select **Log in with OIDC**. This will redirect you to the Okta
   login page for your application.
3. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
