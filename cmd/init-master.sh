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

echo === Init first kubernetes master

if exec_remote ! test -f /etc/kubernetes/kubelet.conf; then
    # Using flannel networking
    exec_remote_su kubeadm init --pod-network-cidr=10.244.0.0/16
    exec_remote_su kubectl --kubeconfig /etc/kubernetes/admin.conf \
        apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
fi

echo === Get cluster admin credentials

mkdir -p "$(dirname "$kubeconfig")"
exec_remote_su cat /etc/kubernetes/admin.conf > "$kubeconfig"
