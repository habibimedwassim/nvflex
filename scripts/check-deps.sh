#!/bin/sh
set -e

echo "nvflux dependency checker"

need="cmake gcc make nvidia-smi gzip"
missing=""
for cmd in $need; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing="$missing $cmd"
    fi
done

if [ -z "$missing" ]; then
    echo "All basic dependencies present."
    exit 0
fi

echo "Missing:$missing"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    id_like="${ID_LIKE:-$ID}"
else
    id_like=""
fi

echo "Install suggestions by distro:"
case "$id_like" in
    *debian*|*ubuntu*|debian|ubuntu)
        echo "  sudo apt update && sudo apt install build-essential cmake gzip nvidia-utils"
        ;;
    *arch*|arch)
        echo "  sudo pacman -Syu base-devel cmake gzip nvidia-utils"
        ;;
    *rhel*|*fedora*|fedora)
        echo "  sudo dnf install @development-tools cmake gzip"
        echo "  # NVIDIA: install vendor/RPM Fusion packages (nvidia-utils)"
        ;;
    *suse*|suse)
        echo "  sudo zypper install -t pattern devel_C_C++ cmake gzip"
        ;;
    *void*|void)
        echo "  sudo xbps-install -S base-devel cmake gzip nvidia-utils"
        ;;
    *)
        echo "  Install a C compiler, cmake or make, and the NVIDIA driver utilities for your distro."
        ;;
esac

exit 2