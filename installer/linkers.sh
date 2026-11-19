#!/bin/bash

# Shared by the installer and dot doctor so their expected links cannot drift.
dotfiles_links() {
  local repo=$1 file config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
  for file in .zshrc .bash_aliases .tmux.conf .gitconfig .p10k.zsh .vimrc .bash_functions; do
    printf '%s\t%s\n' "$repo/$file" "$HOME/$file"
  done
  printf '%s\t%s\n' \
    "$repo/nvim" "$config_dir/nvim" \
    "$repo/.config/htop/htoprc" "$config_dir/htop/htoprc" \
    "$repo/.config/k9s" "$config_dir/k9s"
}

create_link_with_backup() {
  local target_file=$1 home_link=$2 dry_run=${3:-} backup='' suffix=0
  target_file=$(realpath -e -- "$target_file") || return 1
  if [[ -L $home_link && $(readlink -f -- "$home_link") == "$target_file" ]]; then
    printf 'Already linked: %s\n' "$home_link"
    return 0
  fi

  if [[ -e $home_link || -L $home_link ]]; then
    backup="$home_link.bak.$(date -u +%Y%m%dT%H%M%S).$$"
    while [[ -e $backup || -L $backup ]]; do
      suffix=$((suffix + 1))
      backup="$home_link.bak.$(date -u +%Y%m%dT%H%M%S).$$.$suffix"
    done
  fi
  if [[ $dry_run == --dry-run ]]; then
    [[ -z $backup ]] || printf 'Would back up: %s -> %s\n' "$home_link" "$backup"
    printf 'Would link: %s -> %s\n' "$home_link" "$target_file"
    return 0
  fi

  mkdir -p -- "$(dirname -- "$home_link")" || return 1
  if [[ -n $backup ]]; then
    mv -T -- "$home_link" "$backup" || return 1
    printf 'Backed up: %s\n' "$backup"
  fi
  if ! ln -sT -- "$target_file" "$home_link"; then
    [[ -z $backup ]] || mv -T -- "$backup" "$home_link"
    return 1
  fi
  printf 'Linked: %s -> %s\n' "$home_link" "$target_file"
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  set -euo pipefail
  if (( $# > 1 )) || [[ ${1:-} != '' && ${1:-} != --dry-run ]]; then
    echo 'Usage: installer/linkers.sh [--dry-run]' >&2
    exit 2
  fi
  repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
  while IFS=$'\t' read -r source_file destination; do
    create_link_with_backup "$source_file" "$destination" "${1:-}"
  done < <(dotfiles_links "$repo")
fi
