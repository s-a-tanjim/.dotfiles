#/bin/bash

# This script creates a symbolic link in the home directory to a specified file.

create_link_with_backup() {
  local target_file="$1"
  local filename
  local home_link

  # Check if the file exists
  if [ ! -f "$target_file" ]; then
    echo "Error: File '$target_file' does not exist."
    return 1
  fi

  # Extract just the filename
  filename=$(basename "$target_file")
  home_link="$HOME/$filename"

  # If a file/link already exists in the home directory, move it to a .bak
  if [ -e "$home_link" ]; then
    mv "$home_link" "$home_link.bak"
    echo "Existing file/link moved to '$home_link.bak'"
  fi

  # Create symbolic link
  ln -s "$(realpath "$target_file")" "$home_link"
  echo "Symbolic link created at '$home_link'"
}

create_link_with_backup "./.zshrc"
create_link_with_backup "./.bash_aliases"
create_link_with_backup "./.tmux.conf"
create_link_with_backup "./.gitconfig"
create_link_with_backup "./.p10k.zsh"
create_link_with_backup "./.vimrc"
create_link_with_backup "./.bash_functions"
