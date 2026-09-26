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

# Ctrl-T: files
# - Keep the filename/right side visible for long paths
# - Give most of the screen to the file preview
export FZF_CTRL_T_OPTS="
  --keep-right
  --ellipsis '…'
  --preview 'printf \"\033[1m%s\033[0m\n\033[2m%s\033[0m\n\n\" \"\$(basename {})\" \"\$(dirname {})\"; bat --style=numbers --color=always --line-range :500 {}'
  --preview-window 'right:75%:border-left'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Alt-C: directories
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --keep-right
  --ellipsis '…'
  --preview 'ls -la {} | head -100'
  --preview-window 'right:75%:border-left'
"
