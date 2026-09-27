# dotfiles

## Bootstrap on fresh machine

Remember to set profile below, to: `personal` (MacOs), `server` (Linux) or `work` (coming, Ubuntu).

```bash
curl https://mise.run | sh && \
export PATH="$HOME/.local/bin:$PATH" && \
mise -E personal bootstrap --adopt git@github.com:joelbits/dotfiles.git --yes
```
