exec_remote_stdin() {
    cat ${base_directory}/util/executor.sh - | \
        ssh -o SendEnv=LC_password -i ${ssh_key} ${user}@${host} sh -e "$@"
}

exec_remote() {
    echo "$@" | exec_remote_stdin
}

exec_remote_su() {
    echo sudo "$@" | exec_remote_stdin
}
