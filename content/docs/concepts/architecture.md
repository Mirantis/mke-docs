---
title: Architecture
weight: 1
---

Mirantis Kubernetes Engine (MKE) 4k is an enterprise-grade, production-ready
Kubernetes platform that is designed to be secure, scalable, and reliable.

You can manage the entire MKE 4k cluster through the mke4.yaml configuration
file. Refer to [Configuration](../configuration) for details.

## Components

The following components constitute an MKE 4k cluster:

- k0s Kubernetes distribution
- Container Network Interface (CNI)
- MKE 4k Control Plane
  - `mke-operator`
  - `kordent`
- System services
- User services

### k0s Kubernetes distribution

k0s is a lightweight and open-source Kubernetes distribution that acts as the
foundational runtime for MKE 4k clusters. For more information, refer to the
[k0s documentation](https://docs.k0sproject.io/stable/).

### Container Network Interface (CNI)

MKE 4k supports Container Network Interface (CNI) plugins. Such components
provide networking functionality within a cluster that is secure, scalable, and
policy-driven.

MKE 4k installs with the Calico CNI by default. Other CNI options, though, such
as Kube-router, are also available. Refer to [Container Network
Interface](../cni) for the network configuration details.

### MKE 4k Control Plane

The MKE 4k Control Plane, which comprises `mke-operator` and `kordent`,
is used to orchestrate, manage, and maintain the lifecycle of the MKE 4k
cluster and services.

- `mke-operator`: A Kubernetes-native operator that automates installation,
  upgrades, system configuration, and user services.
- `k0rdent`: An open-source component that performs lifecycle management for
  the services that `mke-operator` configures.

### System services

A key benefit of MKE 4k is that it includes various services that are typically
standard to a cluster, thus ensuring that they integrate well and are easy to
use and configure. These services are Kubernetes workloads that run within the
cluster, which you can manage using the MKE 4k control plane. They include
authorization, ingress, monitoring, and backups, among others.

### User Services

Typically, user services are user-defined applications that run within the MKE
4k cluster, which you manage using the MKE 4k control plane.

## Architecture Diagram

<img src="/mke-docs/images/mke4-architecture.drawio.svg" id="myBtn"></img>

<div id="myModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <img src="/mke-docs/images/mke4-architecture.drawio.svg">
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