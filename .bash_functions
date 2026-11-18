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
