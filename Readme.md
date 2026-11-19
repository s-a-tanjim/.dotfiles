# Dotfiles

## Setup (Ubuntu)

```sh
git clone https://github.com/s-a-tanjim/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run  # Preview changes
./install.sh
```

Log out and back in, then select `MesloLGS NF` as your terminal font.
Existing configs are backed up before linking.

Windows: see [win/README.md](win/README.md).

## Local settings

Create `~/.gitconfig.local`:

```ini
[user]
  email = you@example.com
  signingkey = <gpg key id>
```

For shell overrides, copy `example/.zshrc.local.example` to `~/.zshrc.local`.
It loads last; open a new terminal after editing it.

After `p10k configure`, run `exec zsh` to reload the prompt overrides kept in `.zshrc`.

## Helpers

- `dot doctor` — check dependencies, config links, and Git settings.
- `awsprofile` — pick an AWS profile (requires AWS CLI and fzf).

Tests: `python3 -B -m unittest discover -s tests -v`.
