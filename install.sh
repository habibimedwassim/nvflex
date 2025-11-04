#!/bin/sh
set -e
# install.sh - build and install nvflux (setuid root)

SRC=nvflux.c
OUT=/usr/local/bin/nvflux

echo "Building nvflux..."
gcc -O2 -Wall -o nvflux "$SRC"

echo "Installing to $OUT ..."
install -Dm755 nvflux "$OUT"

echo "Setting owner root:root and setuid bit..."
chown root:root "$OUT"
chmod 4755 "$OUT"

# Setup state directory for the installing user (SUDO_USER if present)
user=${SUDO_USER:-$(logname 2>/dev/null || whoami)}
home_dir=$(eval echo "~$user")
state_dir="$home_dir/.local/state/nvflux"
echo "Creating state dir for user '$user' at $state_dir"
mkdir -p "$state_dir"
chown -R "$user":"$user" "$home_dir/.local"

echo "Done. nvflux installed as setuid root."
echo "Usage examples (no sudo required):"
echo "  nvflux performance"
echo "  nvflux balanced"
echo "  nvflux powersaver"
echo "  nvflux reset"
echo "  nvflux status"
echo "  nvflux clock"
echo
echo "To reapply last saved mode on login, add to your WM autostart:"
echo "  exec --no-startup-id nvflux --restore"
echo