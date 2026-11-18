#!/bin/bash

sudo apt update
sudo apt install -y build-essential git curl htop net-tools zsh xclip tmux fzf git-delta ripgrep jq vim

# Configure zsh
export RUNZSH=no
export CHSH=yes
export KEEP_ZSHRC=yes
[ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

clone_if_missing() {
  [ -d "$2" ] || git clone --depth 1 "$1" "$2"
}

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/joshskidmore/zsh-fzf-history-search "$ZSH_CUSTOM/plugins/zsh-fzf-history-search"

# Vim plugin manager (run :PluginInstall in vim afterwards)
clone_if_missing https://github.com/gmarik/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"

# Install neovim
nvim_tar="$(mktemp)"
curl -fLo "$nvim_tar" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz &&
  sudo rm -rf /opt/nvim-linux-x86_64 &&
  sudo tar -C /opt -xzf "$nvim_tar"
rm -f "$nvim_tar"

# Install fonts (MesloLGS NF, used by powerlevel10k)
mkdir -p ~/.local/share/fonts
cp fonts/*.ttf ~/.local/share/fonts/
fc-cache -f
