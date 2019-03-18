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

echo === Join kubernetes cluster

get_join_cmd() (
    host="$(sed -E '/server:/!d ; s/.*https?:\/\/(.+):.*/\1/' "$kubeconfig")"
    exec_remote_su kubeadm token create --print-join-command
)

exec_remote_su "$(get_join_cmd)"
