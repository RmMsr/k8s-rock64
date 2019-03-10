# Why?

We want to run a stable Kubernetes (k8s) cluster on multiple small Single Board Computers (SBC).

## Current state

The scripts in this repo allow automated bootstraping of a single node k8s. We use [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/) to manage the cluster.

## What's next?

* Export credentials (kubeconfig) to remote access the cluster
* Joining more nodes to the cluster
* Adding additional storage

# Hardware

This is implemented on a few [Rock64 boards](http://wiki.pine64.org/index.php/ROCK64_Main_Page) from Pine64. This board is especially interesting because of its moderate price  for relatively good compute power. It features 4 GiB of RAM and a quad core CPU as well as fast IO in form of eMMC storage, 1 Gbit ethernet and USB 3.0.

# Setup

## Operating system

Currently the OS is a Debian image provided by [ayufan](https://github.com/ayufan). Thanks a lot!

1. Get the latest `stretch-minimal-rock64-*` image from [ayufan's  Rock64 releases](https://github.com/ayufan-rock64/linux-build/releases/latest) and unpack it (e.g. with `xz --uncompress`).

2. Write the image to the eMMC or sdcard using `dd` or [Etcher](https://www.balena.io/etcher/) for more convenience.
3. Boot the new image with attached network cable. We depend on internet access configured via DHCP. We will adress the machine (host) from now on by its local IP address.

## Initial setup

Now we can install and configure our k8s stack. We assume that you save the rock64's IP address in the shell variable `$host`.

1. Run `cmd/enable-ssh.sh $host`
   This will establish key based authentication for SSH. Login with password will no longer work from remote. Your private key is stored in `ssh/client`. Don't lose it.
2. Run `cmd/install-dependencies.sh $host`
   Installs needed software for a k8s node (e.g. docker, kubeadm and kubectl)
