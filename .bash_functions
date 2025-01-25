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

basename() {
  # Usage: basename "path" ["suffix"]

  # Strip all trailing forward-slashes '/' from
  # the end of the string.
  #
  # "${1##*[!/]}": Remove all non-forward-slashes
  # from the start of the string, leaving us with only
  # the trailing slashes.
  # "${1%%"${}"}:  Remove the result of the above
  # substitution (a string of forward slashes) from the
  # end of the original string.
  dir=${1%${1##*[!/]}}

  # Remove everything before the final forward-slash '/'.
  dir=${dir##*/}

  # If a suffix was passed to the function, remove it from
  # the end of the resulting string.
  dir=${dir%"$2"}

  # Print the resulting string and if it is empty,
  # print '/'.
  printf '%s\n' "${dir:-/}"
}