# Shared interactive Bash setup

export PATH="$HOME/.local/bin:$PATH"

[ -f "$HOME/.common.sh" ] && source "$HOME/.common.sh"

command -v mise >/dev/null 2>&1 &&
    eval "$(mise activate bash)"

command -v fzf >/dev/null 2>&1 &&
    eval "$(fzf --bash)"

command -v zoxide >/dev/null 2>&1 &&
    eval "$(zoxide init bash)"

command -v starship >/dev/null 2>&1 &&
    eval "$(starship init bash)"

[ -f "$HOME/.config/shell/completion.bash" ] &&
    source "$HOME/.config/shell/completion.bash"