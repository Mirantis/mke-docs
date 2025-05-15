---
title: MKE 4k Dashboard
weight: 6
---

The MKE 4k Dashboard add-on provides a web UI that you can use to manage
Kubernetes resources:

<img src="/mke-docs/images/ui-preview.png" id="myBtn"></img>

<div id="myModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <img src="/mke-docs/images/ui-preview.png">
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

To access the MKE 4k Dashboard, which is enabled by default, navigate to the
address of the load balancer endpoint from a freshly installed cluster. Refer
to [Load balancer requirements](../../getting-started/system-requirements#load-balancer-requirements) for detailed information.

