#!/usr/bin/env bash
# Module: Universal Package Installer for Target Distro

install_manifests() {
    local source_dir="$1/manifests"
    local family="$2"
    local pkg_mgr="$3"

    echo "=== [1/3] MEMERIKSA & MENGINSTALL DEPENDENSI APLIKASI ==="

    if [ ! -d "$source_dir" ]; then
        echo "  [SKIP] Tidak ditemukan folder manifest package."
        return 0
    fi

    # 1. Base Essentials
    echo "  -> Memeriksa paket dasar sistem..."
    case "$family" in
        debian)
            sudo apt-get update -y
            sudo apt-get install -y curl wget git rsync zstd tar python3 python3-pip nodejs npm build-essential
            ;;
        arch)
            sudo pacman -Sy --needed --noconfirm curl wget git rsync zstd tar python python-pip nodejs npm base-devel
            ;;
        fedora)
            sudo dnf install -y curl wget git rsync zstd tar python3 python3-pip nodejs npm make automake gcc gcc-c++
            ;;
        *)
            echo "  [WARN] Distro family ($family) belum didukung untuk auto-install paket dasar."
            ;;
    esac

    # 2. Flatpak apps restore
    if [ -f "$source_dir/flatpak_apps.txt" ] && command -v flatpak >/dev/null 2>&1; then
        echo "  -> Menginstall aplikasi Flatpak..."
        while read -r app; do
            [ -z "$app" ] && continue
            flatpak install -y flathub "$app" 2>/dev/null || true
        done < "$source_dir/flatpak_apps.txt"
    fi

    echo "  [OK] Instalasi paket dasar selesai."
}
