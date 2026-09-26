source ~/.common.sh

# macOS
if [[ "$OSTYPE" == darwin* ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# mise
eval "$(mise activate zsh)"

# prompt
eval "$(starship init zsh)"