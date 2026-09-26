source ~/.common.sh

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

# prompt
eval "$(starship init zsh)"