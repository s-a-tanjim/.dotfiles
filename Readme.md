# Dotfiles

## New device setup (Ubuntu)

```sh
# 1. Clone
git clone https://github.com/s-a-tanjim/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Install packages, oh-my-zsh + plugins, neovim, fonts, and symlink configs
./install.sh

# 3. Log out and back in for zsh to become the default shell
```

Then select `MesloLGS NF` as the font in the terminal profile.

Existing dotfiles in `$HOME` are backed up as `<name>.bak`.

Git identity is per machine. Create `~/.gitconfig.local`:

```ini
[user]
  email = you@example.com
  signingkey = <gpg key id>
```

Windows: see [win/README.md](win/README.md).
