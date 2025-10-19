#!/bin/bash

check_and_install_dep() {
  # Parameter: dependency name
  local dep_name=$1

  # Check if the dependency is installed
  if dpkg -l | grep -q "^ii  $dep_name "; then
    echo "$dep_name is already installed."
  else
    echo "$dep_name is not installed. Installing..."
    sudo apt install -y "$dep_name"
  fi
}

check_and_install_dep build-essential
check_and_install_dep git
check_and_install_dep curl
check_and_install_dep htop
check_and_install_dep net-tools
check_and_install_dep zsh
check_and_install_dep xclip
check_and_install_dep tmux
check_and_install_dep fzf

# Configure zsh
export RUNZSH=no
export CHSH=yes
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mkdir -p $HOME/.oh-my-zsh/custom/plugins
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth 1 https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

# Install kubectl autocomplete
if [ -x "$(command -v kubectl)" ]; then
  mkdir -p ~/.oh-my-zsh/custom/plugins/kubectl-autocomplete/
  kubectl completion zsh > ~/.oh-my-zsh/custom/plugins/kubectl-autocomplete/kubectl-autocomplete.plugin.zsh
fi

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
