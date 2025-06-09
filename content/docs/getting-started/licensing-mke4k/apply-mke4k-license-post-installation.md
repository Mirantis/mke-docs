---
title: Apply an MKE 4k license following installation
weight: 4
---

{{< callout type="warning" >}}

You must have a valid license to lawfully run MKE 4k. For more
information, refer to [Mirantis Agreements and Terms](https://legal.mirantis.com/).

{{< /callout >}}

If you did not set your MKE 4k license in the MKE 4k configuration file prior
to installation, you can use the MKE 4k web UI to apply the license:

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
