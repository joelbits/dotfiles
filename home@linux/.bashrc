# Stop for non-interactive shells
[[ $- != *i* ]] && return

# mise itself is installed here by the mise installer
export PATH="$HOME/.local/bin:$PATH"

# History
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend
shopt -s cmdhist

# Update terminal dimensions
shopt -s checkwinsize

# Better less defaults
export LESS='-R -F -X'

# lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors \
        && eval "$(dircolors -b ~/.dircolors)" \
        || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Shared config
[ -f ~/.common.sh ] && source ~/.common.sh

# Tool manager
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Bash completion
[ -f ~/.config/shell/completion.bash ] &&
    source ~/.config/shell/completion.bash
