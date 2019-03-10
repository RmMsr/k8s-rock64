#!/usr/bin/env sh

set -e

cd "$(dirname "$0")/.."
. ./util/init.sh

usage() {
    echo Usage:
    echo \ \ "$0" host
    exit 1
}

host="${1}"
if [ -z "$host" ]; then
    echo Host not specified! 1>&2
    usage
fi

echo === Updating system

exec_remote_su apt-get update
exec_remote_su apt-get dist-upgrade --yes

echo === Installing Docker

# shellcheck disable=SC2119
exec_remote_stdin <<CMD
    sudo apt-get install --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
CMD

# shellcheck disable=SC2119
exec_remote_stdin <<CMD
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo sh -c "echo deb [arch=arm64] \
        https://download.docker.com/linux/debian \$(lsb_release -cs) stable \
        > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update
    sudo apt-get install --yes docker-ce=${docker_version}
    sudo apt-mark hold docker-ce
CMD

echo === Install kubeadm, kubectl and kubelet

# shellcheck disable=SC2119
exec_remote_stdin <<CMD
    sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | sudo apt-key add -
    sudo sh -c "echo deb [arch=arm64] \
        https://apt.kubernetes.io/ kubernetes-xenial main \
        > /etc/apt/sources.list.d/kubernetes.list"
    sudo apt-get update
    sudo apt-get install --yes kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
CMD

echo === Initializing reboot if needed

if exec_remote test -f /var/run/reboot-required; then
    echo Reboot ...
    exec_remote_su reboot || true
    sleep 30
    exec_remote echo Done
else
    echo No reboot required
fi
