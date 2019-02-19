#!/usr/bin/env sh

set -e

source "$(dirname $0)/vars-local.sh"
source "$(dirname $0)/vars-remote.sh"
source "$directory/utils.sh"

function usage() {
    echo Usage:
    echo "  $0 host"
    exit 1
}

if [ -z $host ]; then
    echo Host not specified! 1>&2
    usage
fi

echo === Init first kubernetes master

# Using flannel networking
exec_remote_su kubeadm init --pod-network-cidr=10.244.0.0/16
exec_remote_su kubectl --kubeconfig /etc/kubernetes/admin.conf \
    apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml

