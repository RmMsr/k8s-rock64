# Why?

We want to run a stable Kubernetes (k8s) cluster on multiple small Single Board Computers (SBC).

## Current state

The scripts in this repo allow automated bootstraping of a single node k8s. We use [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/) to manage the cluster.

## What's next?

* Export credentials (kubeconfig) to remote access the cluster
* Joining more nodes to the cluster
* Adding additional storage

# Hardware

This is implemented on a few [Rock64 boards](https://www.pine64.org/?page_id=7147) from Pine64. This board is especially interesting because of its moderate price  for relatively good compute power. It features 4 GiB of RAM and a quad core CPU as well as fast IO in form of 1 GBit ethernet and USB 3.0.