# Editor
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"

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

mise-server() {
  local host="${1:?usage: mise-server root@HOST}"

  echo "==> Preparing $host"
  ssh "$host" '
    command -v apt-get >/dev/null || {
      echo "ERROR: mise-server currently requires an apt-based system"
      exit 1
    }

    apt-get update &&
    apt-get install -y git curl &&
    {
      [ ! -f ~/.bashrc ] ||
      [ -e ~/.bashrc.bak ] ||
      mv ~/.bashrc ~/.bashrc.bak
    }
  ' || return

  echo "==> Bootstrapping $host"
  mise bootstrap remote \
    --host "$host" \
    --install-mise \
    --adopt https://github.com/joelbits/dotfiles.git \
    --remote-env server \
    --yes
}

mig() {
  if [ $# -eq 0 ]; then
    echo "usage: mig [personal|server|work] <tool[@version]>..."
    return 1
  fi

  local config="$HOME/.config/mise/config.toml"

  case "$1" in
    personal|server|work)
      config="$HOME/.config/mise/config.$1.toml"
      shift
      ;;
  esac

  if [ $# -eq 0 ]; then
    echo "usage: mig [personal|server|work] <tool[@version]>..."
    return 1
  fi

  mise use --path "$config" "$@" &&
    mise dot save &&
    mise dot sync
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

# ── Live code search ──────────────────────────────

fzg() {
  local selected

  selected=$(
    fzf --ansi \
        --disabled \
        --delimiter : \
        --bind "start:reload:rg --column --line-number --no-heading --color=always --smart-case '' || true" \
        --bind "change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || true" \
        --preview 'printf "\033[1m%s\033[0m\n\033[2m%s • line %s\033[0m\n\n" "$(basename {1})" "$(dirname {1})" "{2}"; bat --color=always --style=numbers --highlight-line {2} {1}' \
        --preview-window 'right:75%:border-left:+{2}-3' \
        --header 'Live grep • type to search code • Enter to open' \
        --bind 'ctrl-/:change-preview-window(down|hidden|)'
  ) || return

  [ -z "$selected" ] && return

  local file line
  file=$(printf '%s' "$selected" | cut -d: -f1)
  line=$(printf '%s' "$selected" | cut -d: -f2)

  _fzg_open "$file" "$line"
}

_fzg_open() {
  local file="$1"
  local line="$2"
  local editor="${FZG_EDITOR:-$EDITOR}"

  case "$editor" in
    code)
      code --goto "$file:$line"
      ;;
    idea)
      idea --line "$line" "$file"
      ;;
    vim|nvim)
      "$editor" "+$line" "$file"
      ;;
    *)
      "$editor" "$file"
      ;;
  esac
}