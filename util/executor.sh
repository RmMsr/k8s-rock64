#!/usr/bin/env sh

# Enable for bash
#shopt -s expand_aliases

cleanup() { rm "$askpass"; }
trap cleanup 0 2 # cleanup on exit and kill

mkdir -p "$HOME/script"
askpass=$(mktemp)
chmod +x "$askpass"

# shellcheck disable=SC2154
cat << ASK > "$askpass"
#!/usr/bin/env sh
echo "$LC_password"
ASK

export SUDO_ASKPASS="$askpass"
alias sudo="sudo --askpass"
