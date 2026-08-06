#!/usr/bin/env sh
set -eu

target="codex-user"
project_root=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) target="$2"; shift 2 ;;
    --project-root) project_root="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

skill_name="ketupa-antenna-designer"
codex_home=${CODEX_HOME:-"$HOME/.codex"}
case "$target" in
  codex-user) destinations="$codex_home/skills/$skill_name" ;;
  claude-user) destinations="$HOME/.claude/skills/$skill_name" ;;
  all-user) destinations="$codex_home/skills/$skill_name
$HOME/.claude/skills/$skill_name" ;;
  codex-project)
    [ -n "$project_root" ] || { echo "--project-root is required" >&2; exit 2; }
    destinations="$project_root/.agents/skills/$skill_name"
    ;;
  claude-project)
    [ -n "$project_root" ] || { echo "--project-root is required" >&2; exit 2; }
    destinations="$project_root/.claude/skills/$skill_name"
    ;;
  *) echo "Invalid --target: $target" >&2; exit 2 ;;
esac

printf '%s\n' "$destinations" | while IFS= read -r destination; do
  [ -n "$destination" ] || continue
  if [ -e "$destination" ]; then
    rm -rf -- "$destination"
    echo "Removed: $destination"
  else
    echo "Not installed: $destination"
  fi
done
