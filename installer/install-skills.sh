#!/bin/bash

# Installs agent skills globally by symlinking each skill from this repo's
# ./.agents/skills directory into every agent's global skills location.
#
# The canonical source follows the open ".agents" convention. We mirror it
# into ~/.agents/skills (the open standard global location any compliant
# agent reads) and into ~/.claude/skills (Claude Code, which does not read
# ~/.agents/skills yet). Add more destinations to SKILLS_DESTS as needed.

# Resolve the dotfiles repo root relative to this script so it works from
# any working directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/../.agents/skills"

SKILLS_DESTS=(
  "$HOME/.agents/skills"   # open ".agents" standard
  "$HOME/.claude/skills"   # Claude Code
)

if [ ! -d "$SKILLS_SRC" ]; then
  echo "Error: skills directory '$SKILLS_SRC' does not exist."
  exit 1
fi

# Link a single skill directory into a single destination, replacing any
# existing link and backing up real files/dirs.
link_skill() {
  local target="$1"
  local link="$2"
  local skill_name
  skill_name="$(basename "$target")"

  if [ -L "$link" ]; then
    rm "$link"
  elif [ -e "$link" ]; then
    mv "$link" "$link.bak"
    echo "Existing '$link' moved to '$link.bak'"
  fi

  ln -s "$target" "$link"
  echo "Linked '$skill_name' -> '$link'"
}

for dest in "${SKILLS_DESTS[@]}"; do
  echo "Installing skills into '$dest'"
  mkdir -p "$dest"

  for skill_dir in "$SKILLS_SRC"/*/; do
    # Guard against no matches (literal glob when directory is empty).
    [ -d "$skill_dir" ] || continue
    link_skill "$(realpath "$skill_dir")" "$dest/$(basename "$skill_dir")"
  done
done

echo "Done."
