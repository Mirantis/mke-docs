---
title: Create SAML application in Okta
weight: 4
---

1. Select **SAML 2.0** for **Sign-in method**.
2. For **App name**, choose a name that you can easily remember.
3. Configure the host for your redirect URLs:
   - Single sign-on URL: `http://{MKE hostname}/callback`
   - Audience URI (SP Entity ID): `http://{MKE hostname}/callback`
   - Attribute statements:
     - Name: email
       <br>Value: user.email
     - Name: name
       <br>Value: user.login
4. Click **Save**.
5. Click **Finish**.
6. Navigate to the **Assignments** tab:

   a. Click **Assign** -> **Assign to people**.

   b. Click the blue **Assign** button that corresponds to the account you want to use for authentication.

    Okta generates the `ssoURL` and certificate under the `Sign On` tab.
    The `ssoURL` is the MetadataURL with the final metadata removed from the path.

7. Download the certificate to the system from which you will run mkectl:

    a. Navigate to the SAML **Signing Certificates** section.

    b. Click **Actions** for the active certificate and initiate the download.

8. Configure the `localCa` to point to the downloaded certificate file.
9. Run the `mkectl apply` command with your MKE configuration file.
