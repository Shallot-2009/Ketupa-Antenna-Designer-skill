#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=$(CDPATH= cd -- "$script_dir/.." && pwd)

case "$(uname -s 2>/dev/null || echo unknown)" in
  MINGW*|MSYS*|CYGWIN*) exec "$root/bin/windows/ketupa-antenna.exe" "$@" ;;
esac

if [ -x "$root/bin/linux/ketupa-antenna" ]; then
  exec "$root/bin/linux/ketupa-antenna" "$@"
fi

echo "Ketupa Antenna Designer 1.0.0 has no native Linux binary in this Windows-built package." >&2
echo "Use the HTTP API described in references/API.md or install a native Linux build." >&2
exit 126

