# dotfiles

## Bootstrap on fresh machine

### From local machine -> remote setup

```bash
HOST=root@192.168.1.186; ssh "$HOST" 'apt-get update && apt-get install -y git curl && { [ ! -f ~/.bashrc ] || [ -e ~/.bashrc.bak ] || mv ~/.bashrc ~/.bashrc.bak; }' && mise bootstrap remote --host "$HOST" --install-mise --adopt https://github.com/joelbits/dotfiles.git --remote-env server --yes
```

### Inside new machine -> local setup

Remember to set profile below, to: `personal` (MacOs), `server` (Linux) or `work` (coming, Ubuntu). 

```bash
apt-get update && apt-get install -y git curl && { [ ! -f ~/.bashrc ] || [ -e ~/.bashrc.bak ] || mv ~/.bashrc ~/.bashrc.bak; }

curl https://mise.run | sh && \
export PATH="$HOME/.local/bin:$PATH" && \
mise -E personal bootstrap --adopt git@github.com:joelbits/dotfiles.git --yes
```

## Setup Git-profile

`~/.gitconfig.local`:

```toml
[user]
    name = <YOUR_NAME>
    email = <YOUR_EMAIL>
```
