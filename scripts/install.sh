#!/usr/bin/env sh
set -eu

target="codex-user"
project_root=""
force="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) target="$2"; shift 2 ;;
    --project-root) project_root="$2"; shift 2 ;;
    --force) force="1"; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
skill_name="ketupa-antenna-designer"
codex_home=${CODEX_HOME:-"$HOME/.codex"}

destinations=""
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
    if [ "$force" != "1" ]; then
      echo "Destination exists: $destination; use --force" >&2
      exit 3
    fi
    backup="$destination.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$destination" "$backup"
    echo "Existing installation preserved at: $backup"
  fi
  mkdir -p "$(dirname "$destination")"
  cp -R "$skill_root" "$destination"
  test -f "$destination/SKILL.md"
  case "$(uname -s 2>/dev/null || echo unknown)" in
    MINGW*|MSYS*|CYGWIN*)
      version=$($destination/bin/windows/ketupa-antenna.exe --version)
      printf '%s\n' "$version" | grep -q '1\.0\.0'
      catalog=$($destination/bin/windows/ketupa-antenna.exe families)
      printf '%s\n' "$catalog" | grep -Eq '"count"[[:space:]]*:[[:space:]]*38'
      ;;
  esac
  echo "Installed Ketupa Antenna Designer 1.0.0 to: $destination"
done

echo "Open a new Codex task or Claude Code session."
echo "Note: 1.0.0 includes a Windows-native engine; Linux should use the documented HTTP API or a Linux-native build."
