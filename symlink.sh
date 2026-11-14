#!/usr/bin/env bash
# Symlink every skill in this repo (a directory containing SKILL.md) into a target skills directory.
#
# Usage:
#   ./symlink.sh [target-dir]
#
# Examples:
#   ./symlink.sh                                  # -> ~/.claude/skills
#   ./symlink.sh ~/projects/VictoriaMetrics/.claude/skills
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="${1:-$HOME/.claude/skills}"

mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

for skill_md in "$src_dir"/*/SKILL.md; do
  [ -e "$skill_md" ] || continue
  skill_dir="$(dirname "$skill_md")"
  name="$(basename "$skill_dir")"
  link="$target_dir/$name"

  if [ -L "$link" ]; then
    ln -sfn "$skill_dir" "$link"
    echo "updated: $link -> $skill_dir"
  elif [ -e "$link" ]; then
    echo "skipped: $link exists and is not a symlink" >&2
  else
    ln -s "$skill_dir" "$link"
    echo "linked:  $link -> $skill_dir"
  fi
done
