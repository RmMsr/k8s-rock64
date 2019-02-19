#!/usr/bin/env sh

set -e

source "$(dirname $0)/../util/init.sh"

function usage() {
    echo Usage:
    echo \ \ $0 host
    exit 1
}

if [ -z $host ]; then
    echo Host not specified! 1>&2
    usage
fi

echo === Updating system

exec_remote_su apt-get update
exec_remote_su apt-get dist-upgrade --yes

echo === Installing Docker

exec_remote_stdin <<CMD
    sudo apt-get install --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
CMD

exec_remote_stdin <<CMD
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
CMD

exec_remote_stdin <<CMD
    sudo add-apt-repository \
      "deb [arch=arm64] https://download.docker.com/linux/debian \
      \$(lsb_release -cs) \
      stable"
    sudo apt-get update
    sudo apt-get install --yes docker-ce=${docker_version}
    apt-mark hold docker-ce
CMD

echo === Install kubeadm, kubectl and kubelet

exec_remote_stdin <<CMD
	sudo apt-get install -y apt-transport-https curl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=arm64] \
		http://apt.kubernetes.io/ kubernetes-\$(lsb_release -cs) main"
	sudo apt-add-repository "deb [arch=arm64] \
		http://apt.kubernetes.io/ kubernetes-yakkety main"
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
