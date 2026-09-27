# dotfiles

My portable shell and development environment, managed with [mise](https://mise.jdx.dev/).

Supports:

- macOS personal machines
- Ubuntu/Debian servers
- role-specific mise environments
- tracked dotfiles with mise shared history
- reproducible CLI tooling

## Profiles

Shared configuration lives in:

```text
~/.config/mise/config.toml
```

Machine-specific environments currently include:

```text
personal
server
```

Each machine selects its environment through an untracked local config:

```toml
# ~/.miserc.local.toml
env = ["server"]
```

The local file is created automatically during bootstrap.

## Bootstrap a Mac

On a fresh Mac, install Apple's Command Line Tools first:

```bash
xcode-select --install
```

Then bootstrap the personal environment:

```bash
[ ! -f ~/.zshrc ] || [ -e ~/.zshrc.bak ] || mv ~/.zshrc ~/.zshrc.bak; curl https://mise.run | sh && ~/.local/bin/mise bootstrap --adopt https://github.com/joelbits/dotfiles.git --env personal --yes
```

This:

1. preserves an existing `.zshrc` as `.zshrc.bak`
2. installs mise
3. adopts this repository
4. selects the `personal` environment
5. installs the personal tools, packages and dotfiles

Some macOS applications may still require a first launch or OS permission approval.

> The Mac bootstrap has not yet been tested on a completely fresh macOS installation.

## Bootstrap a server

For a fresh Ubuntu/Debian server, the target only needs to be reachable over SSH using a public key:

```bash
mise-server root@HOST
```

This:

1. installs the bootstrap prerequisites
2. preserves the distro's original `.bashrc` as `.bashrc.bak`
3. installs mise
4. adopts this repository
5. selects the `server` environment
6. installs the server tools, packages and dotfiles

The server bootstrap has been tested from a clean Ubuntu 24.04 LXC.

### What `mise-server` does

The helper is defined in the shared shell configuration and roughly performs:

```bash
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
```

## Dotfile workflow

After changing tracked files on a machine:

```bash
mise dot save
mise dot sync
```

On another machine, fetch and apply the changes:

```bash
mise dot sync
mise dot pull
```

Preview incoming changes without applying them:

```bash
mise dot pull --dry-run
```

Check the current state:

```bash
mise dot status
```

If tool, package or other bootstrap declarations changed:

```bash
mise bootstrap
```

## Configuration

The main configuration is split between shared and role-specific files:

```text
~/.config/mise/config.toml
~/.config/mise/config.personal.toml
~/.config/mise/config.server.toml
```

Shared tools and shell configuration live in `config.toml`.

Role-specific tools, packages and environment variables belong in the corresponding environment config.

For example:

```text
personal → macOS applications and personal development tools
server   → kubectl, helm, k9s and other server tooling
```

## Secrets and local configuration

Secrets, credentials and machine-specific configuration are intentionally not tracked.

Examples:

```text
~/.config/secrets/env
~/.gitconfig.local
~/.miserc.local.toml
```

Shell configuration may source local secrets when present, but their contents never belong in this repository.

## Requirements

For remote server bootstrap:

- SSH access using a public key
- an apt-based Ubuntu/Debian target
- `mise` installed on the machine initiating the bootstrap

For macOS bootstrap:

- macOS Command Line Tools
- internet access
