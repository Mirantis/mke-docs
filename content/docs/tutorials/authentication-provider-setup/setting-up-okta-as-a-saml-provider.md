---
title: Setting up Okta as a SAML provider
weight: 2
---

To configure an Okta application to serve as your [SAML authentication](../../../../docs/configuration/authentication/saml) provider for MKE 4:

1. Navigate to (Okta)[https://www.okta.com/] and sign in to your account dashboard.
2. Select **SAML 2.0** for **Sign-in method**.
3. Enter an **App name** that is easy to remember.
4. Configure the host for your redirect URLs:
   - Single sign-on URL: `http://{MKE hostname}/dex/callback`
   - Audience URI (SP Entity ID): `http://{MKE hostname}/dex/callback`
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

## Configure MKE

{{< tabs items="SSO metadata URL,manual" >}}

{{< tab >}}
Okta provides a metadata URL that you can used to configure SAML in MKE. MKE can
retrieve information for all of the SAML configurations in your MKE cluster by
accessing the URL configured to `ssoMetadataURL` in the MKE configuration file.

```yaml
authentication:
  saml:
    enabled: true
    ssoMetadataURL: https://dev-14305804.okta.com/app/exkdtjvsinbvwD5ms5d0/sso/saml/metadata
```

The metadata URL can be found in Okta by navigating to

1. Applications -> Applications -> Your application
2. Click the **Sign On** tab
3. The metadata URL is displayed in the first section of the page.

Example of information provided when you access the `ssoMetadataURL` URL:

```shell
<md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk75pi5do2MzU1t95r7">
<md:IDPSSODescriptor WantAuthnRequestsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
<md:KeyDescriptor use="signing">
<ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
<ds:X509Data>
<ds:X509Certificate>MIIDqDCCApCgAwIBAgIGAYRZVRraMA0GCSqGSIb3DQEBCwUAMIGUMQswCQYDVQQGEwJVUzETMBEG A1UECAwKQ2FsaWZvcm5pYTeWMBQGA1UEBwwNU2FuIEZyYW5jaXNjszENMAsGA1UECgwET2t0YTEU MBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi02NDEwNTAwNjEcMBoGCSqGSIb3DQEJ ARYNaW5mb0Bva3RhLmNvbTAeFw0yMjExMDgyMjIwMDBaFw0zMjExMDgyMjIxMDBaMIGUMQswCQYD VQQGEwJVUzETMBEGA1UECAwKQ2FsaWevcmcpYTEqMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG A1UECgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi02NDEwNTAwNjEc MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCdSIwDQYJKoZIhvcNAcEBBQADggEPADCCAQoC ggEBAMBMAL7j8+FckMRBx9nIllViMRF8Ah/Gfxnjm4r3LqSdAkMnG4lch7jPNxwy43oOzeO55Ee2 oOqO5RyY0LxhNhGgITzMU1l/I7j6Z/T845aaoadkFe6AHr4sA1PWquw7fPRIgVhDJUbBvtPwf8SI +ncMSkoulQ+FitheN8n+o/7obEfKQxvSbdTudDZgPtPAY2G9VMjhYVnwked9u8ZrAj3IckS6UWlB WV/BG/XDn2wawuQco2/sR3qhUi6cvIpXtSkArW4LCqp2PZH/ItgaTSR+UjfiIaQQBUvUq2E2JGO6 SiuGWjNHGo6+S0cT2rgkTKSqLzjME9BeSw9J45HtmY0CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA LoOtDbvh9vQdCpjZ4enLdBBls2cIr7/YRl43Sv0MGcckQYwOk9OZg9uuMsUJTp6fkbjy1kBfbj7R ZSqNTtQGMs8V30kxCfpxFOBUOm6f/pKJvGqkDjOXMLaWMuwM+j//LYw8N9EIEnH8aN4e7sitHL3L ORpQ8I+M9lRUATgzUaz59dLNHHO9sg5ikDE2kL84U9nQAMDXc+vsUordGRUotVlvIuXT8Hv63OSS akpuYR4Jx9l9XV4nOufhmAZh2dKJKd7c+wlQuJNL+xBEax2F6qQfCjzLEnWEx5wt3vT0EtCGLBOU ZIBHiRNuPYueZ9PdRkpWJpscyjZsfbgzhMCbRg==</ds:X509Certificate>
</ds:X509Data>
</ds:KeyInfo>
</md:KeyDescriptor>
<md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat>
<md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat>
<md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-64105006.okta.com/app/dev-63105106_mke_2/exk75pi5do2MzU1t95r7/sso/saml"/>
<md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-63105106.okta.com/app/dev-63105106_mke_2/exk75pi5do2MzU1t95r7/sso/saml"/>
</md:IDPSSODescriptor>
</md:EntityDescriptor>
```

{{< /tab >}}

{{< tab >}}

Manually configuring the SAML service in MKE allows more control over the configuration.

```yaml
authentication:
  saml:
    enabled: true
    ssoURL: https://dev64105006.okta.com/app/dev64105006_mke4saml_1/epkdtszgindywD6mF5s7/sso/saml
    redirectURI: https://{MKE host}/dex/callback
    usernameAttr: name
    emailAttr: email
    caData: |
    -----BEGIN CERTIFICATE-----
MIIDqDCCApCgAwIBAgIGAY+dH+DGMA0GCSqGSIb3DQEBCwUAMIGUMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQcFsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UEdgwET2t0YTEU
MBIG31UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi02NDEwNTAwNjEcMBoGCSqGSIb3DQEJ
ARYNaW5mw0Bva3RhLmNvbTAeFw0yNDA1MjEyMTQ2NDNaFw0zNDA1MjEyMTQ3NDNaMIGUMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG
A1UECgwET2t0YTEUMBIGA1UECwwLUsNPUHJvdmlkZXIxFTATBgNVBAMMDGRldi02NDEwNTAwNjEc
MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALIMen9eTU2foqQGic0xXUNDm34ccf0PRvU4O5HtvMw5aL4peJIPwvOBzdpGaNTbWeshD6RE
w3eMg0TYDPaHFHZZLjMonEZ8xSvM+sBET7+ZvfAkNI/vvsRTadjlwy0lQoK9BQF9FqZb+qXAhz3h
enF/vML8zPe2oFss9JQnRxzEfYaa2xsCt18mZEn8668CT2RvoKZAw7IQ67z+01aIbga6uZk3axDR
q2ozdFJoSDmYwFHRQDAmtHmAfomQfzTuuG+ZY7HV/4Q5Fk8Q4BbtxKoADhnRkCMBNrgYn7g+rscR
24x+dmDWEimHSeXrvKSzObI4WzxP2vAmsO+apmNW60ECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA
qUBeR/TR7tqS3MH8uY+JnzzxJKAhb9bWnMgDM3msIyLAF8CuRSC283Ws5+t11QF+C4pEV4zXRjrM
Z1mNWj4eQEwB4+ZdTy4JhpBavOZSS2WESdAsnRwrYOb+t3FBae7Ay+lPnos5UPjgpV1aw3A6/BYe
kDBBZOSieSGOa6Me2Qx358bb2oiFqBGgXoI22rgmDBvrxTsNMv/4T3/2i3cOjF6YC1vdYLlmqPxw
2HK2OIU6yrLsvYz0W3VZwJFzMAmEPYAwmdzT1G/qpzcuVXJUIy0TS7GuBghcQ8Zfy3ya18aUBlwb
mcw9Dlufaan1XxqnVivuWe3qVSVIWngUOUt2EA==
-----END CERTIFICATE-----
```

This information can be found in Okta b y navigating to

1. Applications -> Applications -> Your application
2. Click the **Sign On** tab
3. Click the `View SAML setup instructions` link on the right side of the page.
4. The `ssoURL` is displayed in the `Identity Provider Single Sign-On URL` section.
5. The certificate is displayed in the `X.509 Certificate` section.
6. The `redirectURI` will be the external address of your cluster with `/dex/callback` appended to the end.
7. The `usernameAttr` and `emailAttr` are the attributes that will be used to map the user's name and email to the MKE user. These can be left the same as the values in the example since that is what Okta was configured to use above.

{{< /tab >}}

{{< /tabs >}}

Run the `mkectl apply` command with your MKE configuration file.

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Select **Log in with OIDC**. This will redirect you to the Okta
   login page for your application.
3. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
