# Installation Guide

## Quick Start

1. **Check dependencies**:
   ```bash
   ./scripts/check-deps.sh
   ```

2. **Install** (requires root):
   ```bash
   sudo ./scripts/install.sh
   ```

3. **Verify installation**:
   ```bash
   nvflux --version
   nvflux status
   ```

## Dependencies

### Runtime Requirements
- **NVIDIA drivers** with `nvidia-smi` utility
- Linux kernel with NVIDIA driver loaded

### Build Requirements
- C compiler (GCC or Clang)
- CMake 3.10+ (preferred) or Make
- gzip (for man page compression)

## Distribution-Specific Instructions

### Debian / Ubuntu
```bash
# Build tools
sudo apt update
sudo apt install build-essential cmake gzip
```

### Arch Linux
```bash
# Build tools
sudo pacman -Syu base-devel cmake gzip
```

### Fedora
```bash
# Build tools
sudo dnf install @development-tools cmake gzip
```

### openSUSE
```bash
# Build tools
sudo zypper install -t pattern devel_C_C++ cmake gzip
```

### Void Linux
```bash
# Build tools
sudo xbps-install -S base-devel cmake gzip
```

## Manual Build

If you prefer manual control:

```bash
# Using CMake (recommended)
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install  # Future feature

# Install manually
sudo install -Dm4755 nvflux /usr/local/bin/nvflux
sudo gzip -c man/nvflux.1 > /usr/local/share/man/man1/nvflux.1.gz
```

## Autostart Configuration

To restore your GPU profile on login:

### i3 / Sway
Add to `~/.config/i3/config` or `~/.config/sway/config`:
```
exec --no-startup-id nvflux --restore
```

### GNOME / KDE / XFCE
Create `~/.config/autostart/nvflux-restore.desktop`:
```ini
[Desktop Entry]
Type=Application
Name=nvflux Profile Restore
Exec=nvflux --restore
X-GNOME-Autostart-enabled=true
```

### systemd user service
Create `~/.config/systemd/user/nvflux-restore.service`:
```ini
[Unit]
Description=Restore NVIDIA GPU profile
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/nvflux --restore

[Install]
WantedBy=default.target
```

Enable: `systemctl --user enable nvflux-restore.service`

## Uninstallation

```bash
sudo ./scripts/uninstall.sh
```

This removes:
- Binary from `/usr/local/bin/nvflux`
- Man page from `/usr/local/share/man/man1/`
- User state directory `~/.local/state/nvflux/`