# Editor
export EDITOR="vim"
export VISUAL="$EDITOR"

# SOPS
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

# Local secrets — never in git
[ -f "$HOME/.config/secrets/env" ] && source "$HOME/.config/secrets/env"

# Aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# Common functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}
