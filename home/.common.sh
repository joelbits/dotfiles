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

# ── fzf ──────────────────────────────────────────

# Use fd instead of find
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# File picker: syntax-highlighted preview
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Directory picker
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview 'ls -la {} | head -100'
"
