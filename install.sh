#!/bin/bash
set -euo pipefail

(( $# <= 1 )) || { echo 'Too many arguments.' >&2; exit 2; }
case "${1:-}" in
  --help)
    echo 'Usage: ./install.sh [--dry-run]'
    echo 'Preview package installation and config links with --dry-run.'
    exit 0 ;;
  ''|--dry-run) ;;
  *) echo 'Usage: ./install.sh [--dry-run]' >&2; exit 2 ;;
esac

# Run from the repo root so the relative paths in the installers resolve
cd "$(dirname "$0")" || exit 1

# Check if the OS is Ubuntu using /etc/os-release
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ "$NAME" == "Ubuntu" ]]; then
    echo "Ubuntu detected. Running ubuntu installer..."
    ./installer/ubuntu.sh "$@"
    ./installer/linkers.sh "$@"

    if [[ ${1:-} == --dry-run ]]; then
      echo 'Would install tmux plugins with TPM and Vim plugins with Vundle.'
      exit 0
    fi

    # tmux plugins (after linkers.sh: install_plugins reads ~/.tmux.conf)
    [ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins

    # vim plugins (after linkers.sh: Vundle reads ~/.vimrc)
    vim +PluginInstall +qall
  else
    echo "OS not supported."
    exit 1
  fi
else
  echo "Unable to determine the OS. /etc/os-release not found."
  exit 1
fi
