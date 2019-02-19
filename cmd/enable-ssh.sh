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

if [ ! -e ${ssh_key} ]; then
    echo === Generating new SSH keypair
    ssh-keygen -f ${ssh_key} -b 4096 -C admin -N ''
else
    echo === Skipping SSH keypair generation
fi

echo === Adding SSH public key to host
export SSH_ASKPASS=${directory}/ssh_pass.sh
# FIXME is setsid required on Linux?
ssh-copy-id -i ${ssh_key} ${user}@${host}

echo === Disabling password authentication
exec_remote_su "sed -i 's/^\#PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config"
exec_remote_su systemctl reload sshd

echo Done
