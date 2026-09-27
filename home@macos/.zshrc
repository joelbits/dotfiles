source ~/.common.sh

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=100000

# Don't save commands prefixed with a space
setopt HIST_IGNORE_SPACE

# Reduce duplicates
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Share history between concurrently running shells
setopt SHARE_HISTORY

# macOS
if [[ "$OSTYPE" == darwin* ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# mise
eval "$(mise activate zsh)"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Ctrl-G - live code search
_fzg_widget() {
  fzg
  zle reset-prompt
}
zle -N _fzg_widget
bindkey '^G' _fzg_widget

# prompt
eval "$(starship init zsh)"
source /Users/joelprivat/.config/broot/launcher/bash/br
