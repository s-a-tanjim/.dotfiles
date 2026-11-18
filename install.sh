#!/bin/bash

# Run from the repo root so the relative paths in the installers resolve
cd "$(dirname "$0")" || exit 1

# Check if the OS is Ubuntu using /etc/os-release
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ "$NAME" == "Ubuntu" ]]; then
    echo "Ubuntu detected. Running ubuntu installer..."
    ./installer/ubuntu.sh
    ./installer/linkers.sh

    # tmux plugins (after linkers.sh: install_plugins reads ~/.tmux.conf)
    [ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins

    # vim plugins (after linkers.sh: Vundle reads ~/.vimrc)
    vim +PluginInstall +qall
  else
    echo "OS not supported."
  fi
else
  echo "Unable to determine the OS. /etc/os-release not found."
fi
