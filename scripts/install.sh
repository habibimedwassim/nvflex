#!/bin/sh
set -e

OUT=/usr/local/bin/nvflux
MANDIR=/usr/local/share/man/man1
MAN_SRC=man/nvflux.1

if [ "$(id -u)" -ne 0 ]; then
    echo "This installer must be run as root (use sudo)." >&2
    exit 1
fi

echo "Checking basic host dependencies..."

missing=""
check() {
    if ! command -v "$1" >/dev/null 2>&1; then
        missing="$missing $1"
    fi
}

# Tools we can use during build (either cmake+make or gcc)
check cmake
check gcc
check make
# runtime tool
check nvidia-smi

if [ -n "$missing" ]; then
    echo "Warning: the following tools are missing:$missing"
    # try to detect os and suggest commands
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        id_like="${ID_LIKE:-$ID}"
    else
        id_like=""
    fi
    echo "Suggested install commands (choose the one matching your distro):"
    case "$id_like" in
        *debian*|*ubuntu*|debian|ubuntu)
            echo "  sudo apt update && sudo apt install build-essential cmake gzip"
            echo "  sudo apt install nvidia-utils    # runtime"
            ;;
        *arch*|arch)
            echo "  sudo pacman -Syu base-devel cmake gzip"
            echo "  sudo pacman -S nvidia-utils"
            ;;
        *rhel*|*fedora*|fedora)
            echo "  sudo dnf install @development-tools cmake gzip"
            echo "  # NVIDIA: install from RPM Fusion or vendor packages"
            ;;
        *suse*|suse)
            echo "  sudo zypper install -t pattern devel_C_C++ cmake gzip"
            echo "  # NVIDIA: install vendor packages"
            ;;
        *void*|void)
            echo "  sudo xbps-install -S base-devel cmake gzip"
            ;;
        *)
            echo "  Install a C compiler and either cmake+make or gcc. Also install nvidia-smi (NVIDIA driver package)."
            ;;
    esac
    echo "You can still continue, but build/install may fail. Install missing packages and rerun installer for best experience."
fi

echo "Building nvflux..."

# Prefer CMake if available and CMakeLists.txt exists
if command -v cmake >/dev/null 2>&1 && [ -f CMakeLists.txt ]; then
    rm -rf build
    mkdir -p build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make -j$(nproc 2>/dev/null || echo 1)
    BUILT_BIN="$(pwd)/nvflux"
    cd ..
else
    # fallback to a simple gcc invocation
    if ! command -v gcc >/dev/null 2>&1; then
        echo "gcc not found; please install a C compiler or install cmake and run again." >&2
        exit 1
    fi
    gcc -O2 -Wall -I include -o nvflux src/nvflux.c src/main.c
    BUILT_BIN="$(pwd)/nvflux"
fi

if [ ! -x "$BUILT_BIN" ]; then
    echo "Build failed: binary not found at $BUILT_BIN" >&2
    exit 1
fi

echo "Installing $BUILT_BIN -> $OUT"
install -Dm755 "$BUILT_BIN" "$OUT"

echo "Setting owner root:root and setuid bit..."
chown root:root "$OUT"
chmod 4755 "$OUT"

# install man page if present
if [ -f "$MAN_SRC" ]; then
    mkdir -p "$MANDIR"
    gzip -c "$MAN_SRC" > "$MANDIR/nvflux.1.gz"
    echo "Installed man page to $MANDIR/nvflux.1.gz"
    if command -v mandb >/dev/null 2>&1; then
        mandb >/dev/null 2>&1 || true
    fi
fi

# Setup state directory for the installing user (SUDO_USER if present)
user=${SUDO_USER:-$(logname 2>/dev/null || whoami)}
home_dir=$(eval echo "~$user")
state_dir="$home_dir/.local/state/nvflux"
echo "Creating state dir for user '$user' at $state_dir"
mkdir -p "$state_dir"
chown -R "$user":"$user" "$home_dir/.local" || true

echo "Done. nvflux installed to $OUT"