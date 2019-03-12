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

echo === Set unique hostname

current_hostname=$(exec_remote hostname)
if [ "$current_hostname" = "$default_hostname" ]; then
    new_hostname=k8s-$(openssl rand -hex 2)
    Echo Changing hostname to "$new_hostname"
    exec_remote_su "sed -i 's/${default_hostname}/${new_hostname}/g' /etc/hosts"
    exec_remote_su "sed -i 's/${default_hostname}/${new_hostname}/g' /etc/hostname"
    exec_remote_su systemctl restart systemd-hostnamed
fi

