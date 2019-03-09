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

if [ ! -e "${ssh_key}" ]; then
    echo === Generating new SSH keypair
    ssh-keygen -f "${ssh_key}" -b 4096 -C admin -N ''
else
    echo === Skipping SSH keypair generation
fi

echo === Adding SSH public key to host
# Try to enable key based auth without user interaction
if command -v setsid > /dev/null; then
    export SSH_ASKPASS=util/ssh-pass.sh
    export DISPLAY=1
    setsid ssh-copy-id -i "${ssh_key}" "${user}@${host}"
elif command -v sshpass > /dev/null; then
    ./util/ssh-pass.sh | sshpass \
        ssh-copy-id -i "${ssh_key}" "${user}@${host}"
else
    ssh-copy-id -i "${ssh_key}" "${user}@${host}"
fi

echo === Disabling password authentication
exec_remote_su "sed -i 's/^\#PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config"
exec_remote_su systemctl reload sshd

echo Done
