countls() {
  local dir="${1:-.}"

  if [ ! -d "$dir" ]; then
    echo "Error: '$dir' is not a valid directory."
    return 1
  fi

  # Output the results
  echo "Directory: $dir"
  echo "Total Files and Directories: $(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)"
  echo "Total Files: $(find "$dir" -mindepth 1 -maxdepth 1 -type f | wc -l)"
  echo "Total Directories: $(find "$dir" -mindepth 1 -maxdepth 1 -type d | wc -l)"
  echo "Total Hidden Files: $(find "$dir" -mindepth 1 -maxdepth 1 -type f -name ".*" | wc -l)"
}


count() {
  # Usage: count /path/to/dir/*
  #        count /path/to/dir/*/
  [ -e "$1" ] \
    && printf '%s\n' "$#" \
    || printf '%s\n' 0
}

dot() {
  bash "${DOTFILES_DIR:-$HOME/.dotfiles}/bin/dot" "$@"
}

_dot_require() {
  local tool
  for tool in "$@"; do
    command -v "$tool" >/dev/null 2>&1 || {
      printf 'Missing command: %s. Run dot doctor for setup checks.\n' "$tool" >&2
      return 1
    }
  done
}

awsprofile() {
  _dot_require aws fzf || return
  if [ -n "${AWS_ACCESS_KEY_ID:-}${AWS_SECRET_ACCESS_KEY:-}${AWS_SESSION_TOKEN:-}${AWS_SECURITY_TOKEN:-}" ]; then
    echo 'Unset AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN and AWS_SECURITY_TOKEN before switching profiles; environment credentials override profiles.' >&2
    return 1
  fi
  local choices selected
  choices=$(AWS_PAGER='' aws configure list-profiles) || return
  [ -n "$choices" ] || { echo 'No AWS profiles configured.' >&2; return 1; }
  selected=$(printf '%s\n' "$choices" | fzf --height=40% --reverse --no-multi --prompt='AWS profile > ') || return
  [ -n "$selected" ] || return 1
  export AWS_PROFILE="$selected" AWS_DEFAULT_PROFILE="$selected" AWS_EB_PROFILE="$selected"
  # Oh My Zsh uses this for its AWS prompt; an absent region is valid.
  export AWS_PROFILE_REGION="$(aws configure get region --profile "$selected" 2>/dev/null)"
  printf 'AWS profile: %s\n' "$AWS_PROFILE"
}
