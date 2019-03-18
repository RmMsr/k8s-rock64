# Why?

We want to run a stable Kubernetes (k8s) cluster on multiple small Single Board Computers (SBC).

## Current state

The scripts in this repo allow automated bootstrapping of a single master k8s. We use [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/) to manage the cluster. The setup roughly follows the [independent k8s setup instructions](https://kubernetes.io/docs/setup/independent/).

## What's next?

* Adding additional storage
* High availability with more than one master and etcd

# Setup

## Hardware

This is implemented on a few [Rock64 boards](http://wiki.pine64.org/index.php/ROCK64_Main_Page) from Pine64. This mini computer is especially interesting because of its moderate price  for relatively good compute power. It features 4 GiB of RAM and a quad core CPU as well as fast IO in form of eMMC storage, 1 Gbit ethernet and USB 3.0.

## Operating system

Currently the OS is the well known rock64 Debian image provided by [ayufan](https://github.com/ayufan). Thanks a lot!

1. Get the latest `stretch-minimal-rock64-*` image from [ayufan's  rock64 releases](https://github.com/ayufan-rock64/linux-build/releases/latest) and unpack it (e.g. with `xz --uncompress`).

2. Write the image to the eMMC or sdcard using `dd` or [Etcher](https://www.balena.io/etcher/) for more convenience.

3. Boot the new image with attached network cable. We depend upon internet access configured via DHCP. From now on we will adress the machine (host) by its local IP address.

## Initial setup

Now we can install and configure our k8s stack. Here we assume that you save the rock64's IP address in the shell variable `$host`.

1. `cmd/enable-ssh.sh $host`

   This will establish key based authentication for SSH. Login with password will no longer work from remote. Your private key is stored in `cluster/id_rsa`. Don't lose it.

2. `cmd/prepare-node.sh $host`

   Ensures a unique hostname for each node.

3. `cmd/install-dependencies.sh $host`

   Installs needed software for a k8s node (e.g. docker, kubeadm and kubectl).

4. `cmd/init-master.sh $host`

   The first k8s node will be configured and started. You can access the k8s API on port `6443` of that host. A complete kubeconfig with cluster admin credentials is exported to `cluster/admin.conf`.

5. `cmd/join-node.sh $host`

   Add more nodes to the cluster. Only the initial node will be a master. All other nodes will not run the k8s api or host an etcd server.