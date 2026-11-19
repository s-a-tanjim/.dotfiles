#!/bin/bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
if (( $# > 1 )) || [[ ${1:-} != '' && ${1:-} != --dry-run ]]; then
  echo 'Usage: installer/ubuntu.sh [--dry-run]' >&2
  exit 2
fi
packages=(build-essential git curl htop net-tools zsh xclip tmux fzf git-delta ripgrep jq vim fontconfig)
case "$(uname -m)" in
  x86_64) nvim_archive=nvim-linux-x86_64 ;;
  aarch64|arm64) nvim_archive=nvim-linux-arm64 ;;
  *) echo 'Unsupported architecture for the Neovim binary.' >&2; exit 1 ;;
esac
if [[ ${1:-} == --dry-run ]]; then
  printf 'Would install Ubuntu packages: %s\n' "${packages[*]}"
  echo 'Would install missing Oh My Zsh, shell plugins and Vundle; select zsh as the login shell.'
  printf 'Would install the latest stable Neovim release (%s) to /opt/nvim, replacing an existing installation.\n' "$nvim_archive"
  echo 'Would install MesloLGS NF fonts and refresh the font cache.'
  exit 0
fi

sudo apt update
sudo apt install -y "${packages[@]}"

download_dir=$(mktemp -d)
trap 'rm -rf -- "$download_dir"' EXIT

# Configure zsh
export RUNZSH=no
export CHSH=yes
export KEEP_ZSHRC=yes
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$download_dir/oh-my-zsh.sh"
  sh "$download_dir/oh-my-zsh.sh"
fi

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

# Extract and validate the latest release before moving an existing installation.
curl -fL "https://github.com/neovim/neovim/releases/latest/download/$nvim_archive.tar.gz" -o "$download_dir/nvim.tar.gz"
tar -C "$download_dir" -xzf "$download_dir/nvim.tar.gz"
"$download_dir/$nvim_archive/bin/nvim" --version >/dev/null
nvim_destination=/opt/nvim
sudo rm -rf -- "$nvim_destination"
sudo mv -T -- "$download_dir/$nvim_archive" "$nvim_destination"
# The archive was extracted as the current user; binaries on PATH belong to root.
sudo chown -R root:root -- "$nvim_destination"

# Install fonts (MesloLGS NF, used by powerlevel10k)
mkdir -p ~/.local/share/fonts
cp fonts/*.ttf ~/.local/share/fonts/
fc-cache -f
