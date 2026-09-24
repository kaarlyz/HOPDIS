#!/usr/bin/env bash
# Module: Universal Package & Toolchain Auto-Installer for Target Distro

install_manifests() {
    local source_dir="$1/manifests"
    local family="$2"
    local pkg_mgr="$3"

    echo "=== [1/3] MEMERIKSA & MENGINSTALL RUNTIME, TOOLCHAIN & PACKAGES ==="

    # 1. Base Essentials
    echo "  -> [1/4] Memasang paket dasar sistem & dependensi CLI..."
    case "$family" in
        debian)
            sudo apt-get update -y
            sudo apt-get install -y curl wget git rsync zstd unzip tar python3 python3-pip python3-venv nodejs npm flatpak build-essential
            ;;
        arch)
            sudo pacman -Sy --needed --noconfirm curl wget git rsync zstd unzip tar python python-pip python-virtualenv nodejs npm flatpak base-devel
            ;;
        fedora)
            sudo dnf install -y curl wget git rsync zstd unzip tar python3 python3-pip python3-virtualenv nodejs npm flatpak make automake gcc gcc-c++
            ;;
        *)
            echo "  [WARN] Distro family ($family) belum didukung untuk auto-install paket dasar."
            ;;
    esac

    # 2. Modern Dev Toolchains (Bun & UV) Auto-Bootstrap
    echo "  -> [2/4] Memeriksa instalasi modern toolchain (Bun & UV)..."
    if ! command -v bun >/dev/null 2>&1; then
        echo "     - Memasang Bun JavaScript runtime..."
        curl -fsSL https://bun.sh/install | bash 2>/dev/null || true
    fi

    if ! command -v uv >/dev/null 2>&1; then
        echo "     - Memasang Astral UV (Python toolchain)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || true
    fi

    # 3. Flathub Remote & Flatpak Apps
    if command -v flatpak >/dev/null 2>&1; then
        echo "  -> [3/4] Memeriksa repository Flathub..."
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

        if [ -f "$source_dir/flatpak_apps.txt" ]; then
            echo "     - Memulihkan aplikasi Flatpak dari manifest..."
            while read -r app; do
                [ -z "$app" ] && continue
                flatpak install -y flathub "$app" 2>/dev/null || true
            done < "$source_dir/flatpak_apps.txt"
        fi
    fi

    # 4. Global NPM Packages Restore
    if [ -f "$source_dir/npm_global.json" ] && command -v npm >/dev/null 2>&1; then
        echo "  -> [4/4] Memeriksa paket NPM global..."
        # Extract package names from JSON if available
        if command -v jq >/dev/null 2>&1; then
            jq -r '.dependencies | keys[]?' "$source_dir/npm_global.json" 2>/dev/null | while read -r pkg; do
                [ -z "$pkg" ] && continue
                echo "     - Memasang NPM global: $pkg"
                sudo npm install -g "$pkg" 2>/dev/null || true
            done
        fi
    fi

    echo "  [OK] Setup dependensi & toolchain otomatis selesai."
}
