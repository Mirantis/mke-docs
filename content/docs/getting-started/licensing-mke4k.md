---
title: Licensing MKE 4k
weight: 2
---

{{< callout type="warning" >}}

You must have a valid license to lawfully run MKE 4k. For more
information, refer to [Mirantis Agreements and Terms](https://legal.mirantis.com/).

{{< /callout >}}

## Obtain your MKE 4k license

[Install the MKE 4k CLI](../install-mke-4k-cli) prior to downloading your MKE
4k license.

1. Locate the Welcome to Mirantis' CloudCare Portal email sent to you from Mirantis
   Support. If you do not have the email, confirm with your Designated Administrator
   that you have been added as a Designated Contact.

2. Click **Environments** in the top navigation bar of the MKE 4k web UI.

3. Click the **Cloud Name** that is associated with the license you want to download.

4. Scroll down to **License Information** and click the **License File URL**. 
   A new tab opens in your browser.

5. Click **View file** to download your license file.

{{< callout type="info" >}}

Though MKE 4k is generally a subscription-only service, you can obtain a free trial license from Mirantis. Make your request using the [Mirantis contact form](https://www.mirantis.com/contact).

{{< /callout >}}

## Add the license

1. Log in to the MKE web UI with an administrator account.
2. In the left-side navigation panel, navigate to **Admin Settings** -> **License**.
3. Insert the license into the **license key** field. To do this, click
   **Choose File** and navigate to the ``.lic`` file you previously downloaded.
   Alternately, you can copy-paste the contents of the ``.lic`` file into the
   field as a text string.

   <img src="/mke-docs/images/add-a-license.png" id="myBtn"></img>

   <div id="myModal" class="modal">
     <div class="modal-content">
       <span class="close">&times;</span>
       <img src="/mke-docs/images/add-a-license.png">
     </div>
   </div>

   <script>
   var modal = document.getElementById("myModal");
   var btn = document.getElementById("myBtn");
   var span = document.getElementsByClassName("close")[0];

   // When the user clicks the button, open the modal
   btn.onclick = function() {
     modal.style.display = "block";
   }

   // When the user clicks on <span> (x), close the modal
   span.onclick = function() {
     modal.style.display = "none";
   }

   // When the user clicks anywhere outside of the modal, close it
   window.onclick = function(event) {
     if (event.target == modal) {
       modal.style.display = "none";
     }
   }
   </script>

   <style>
   .modal {
     display: none; /* Hidden by default */
     position: fixed; /* Stay in place */
     z-index: 1; /* Sit on top */
     padding-top: 100px; /* Location of the box */
     left: 0;
     top: 0;
     width: 90%; /* Full width */
     height: 90%; /* Full height */
     overflow: auto; /* Enable scroll if needed */
     background-color: rgb(0,0,0); /* Fallback color */
     background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
   }

   /* Modal Content */
   .modal-content {
     background-color: #fefefe;
     margin: auto;
     padding: 20px;
     border: 1px solid #888;
     width: 80%;
   }

   /* The Close Button */
   .close {
     color: #aaaaaa;
     float: right;
     font-size: 28px;
     font-weight: bold;
   }

   .close:hover,
   .close:focus {
     color: #000;
     text-decoration: none;
     cursor: pointer;
   }
   </style>

4. Click **Save settings** to update the MKE 4k license.

## Set the license in the configuration

1. Insert the license into ``spec.license.token`` in the `mke4.yaml`
   configuration file:

    ```yaml
    spec:
      license:
        token: <your-license-file>
    ```

2. Apply the license:

   ```commandline
   mkectl apply
   ```

3. Check the license status:

   ```commandline
   kubectl -n mke get mkeconfig mke -ojsonpath="{.status.licenseStatus}" | jq 
   ```

   Example output:
   
   ```json
   {
     "expiration": "2027-10-10T07:00:00Z",
     "licenseType": "Offline",
     "maxEngines": 10,
     "scanningEnabled": true,
     "subject": "example",
     "tier": "Production"
   }
   ```


