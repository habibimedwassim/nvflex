#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This uninstaller must be run as root (use sudo)." >&2
    exit 1
fi

OUT=/usr/local/bin/nvflux
MANDIR=/usr/local/share/man/man1
MAN_PAGE="$MANDIR/nvflux.1.gz"

if [ -f "$OUT" ]; then
    echo "Removing $OUT"
    rm -f "$OUT"
else
    echo "nvflux binary not found at $OUT"
fi

if [ -f "$MAN_PAGE" ]; then
    echo "Removing man page $MAN_PAGE"
    rm -f "$MAN_PAGE"
    if command -v mandb >/dev/null 2>&1; then
        mandb >/dev/null 2>&1 || true
    fi
fi

# Remove installer user's state dir
user=${SUDO_USER:-$(logname 2>/dev/null || whoami)}
home_dir=$(eval echo "~$user")
state_dir="$home_dir/.local/state/nvflux"
if [ -d "$state_dir" ]; then
    echo "Removing user state dir $state_dir"
    rm -rf "$state_dir"
fi

echo "Uninstall complete."