#!/urb/bin/env sh

# shellcheck disable=SC2120,SC2154
exec_remote_stdin() {
    cat "util/executor.sh" - | \
        ssh -o SendEnv=LC_password -i "$ssh_key" "${user}@${host}" sh -e "$@"
}

# shellcheck disable=SC2119
exec_remote() {
    echo "$@" | exec_remote_stdin
}

# shellcheck disable=SC2119
exec_remote_su() {
    echo sudo "$@" | exec_remote_stdin
}
