#!/usr/bin/env bash
# Module: Universal Package & Toolchain Auto-Installer, Shell Sync & AI Bootstrap

install_manifests() {
    local source_dir="$1/manifests"
    local family="$2"

    echo "=== [1/3] MEMERIKSA & MENGINSTALL RUNTIME, TOOLCHAIN & PACKAGES ==="

    # ─── 1. BASE SYSTEM ESSENTIALS ───
    echo "  -> [1/6] Memasang paket dasar sistem & dependensi CLI..."
    case "$family" in
        debian)
            sudo apt-get update -y
            sudo apt-get install -y curl wget git rsync zstd unzip tar \
                python3 python3-pip python3-venv python3-yaml \
                nodejs npm flatpak build-essential || true
            ;;
        arch)
            sudo pacman -Sy --needed --noconfirm curl wget git rsync zstd unzip tar \
                python python-yaml python-dotenv nodejs npm flatpak base-devel || true
            ;;
        fedora)
            sudo dnf install -y curl wget git rsync zstd unzip tar \
                python3 python3-pip python3-virtualenv python3-pyyaml \
                nodejs npm flatpak make automake gcc gcc-c++ || true
            ;;
        suse)
            sudo zypper install -y curl wget git rsync zstd unzip tar \
                python3 python3-pip python3-PyYAML nodejs npm flatpak || true
            ;;
        *)
            echo "  [WARN] Distro family ($family) belum didukung. Pasang manual: git rsync zstd python3 nodejs npm"
            ;;
    esac

    # ─── 2. MODERN DEV TOOLCHAINS (UV & BUN) ───
    echo "  -> [2/6] Memeriksa & memasang modern toolchain (UV & Bun)..."
    if ! command -v uv >/dev/null 2>&1; then
        echo "     Menginstall Astral UV..."
        curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || true
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if ! command -v bun >/dev/null 2>&1; then
        echo "     Menginstall Bun Runtime..."
        curl -fsSL https://bun.sh/install | bash 2>/dev/null || true
        export PATH="$HOME/.bun/bin:$PATH"
    fi

    # ─── 3. BERSIHKAN WRAPPER LOKAL YANG KORUP ───
    echo "  -> [3/6] Membersihkan wrapper lokal lama yang berpotensi korup..."
    # Jangan biarkan ~/.local/bin/npm nge-hijack /usr/bin/npm
    for cmd in npm node npx corepack; do
        if [ -f "/usr/bin/$cmd" ] && [ -f "$HOME/.local/bin/$cmd" ]; then
            rm -f "$HOME/.local/bin/$cmd"
            echo "     Dihapus: ~/.local/bin/$cmd (shadow system binary)"
        fi
    done

    # Hapus folder node lama dari hermes yang bisa bikin MODULE_NOT_FOUND
    if [ -d "$HOME/.hermes/node" ]; then
        rm -rf "$HOME/.hermes/node"
        echo "     Dihapus: ~/.hermes/node/ (runtime lokal usang)"
    fi

    # Hapus dangling symlinks di ~/.local/bin
    find "$HOME/.local/bin" -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true

    # ─── 4. RESTORE FLATPAK APPS ───
    echo "  -> [4/6] Memulihkan aplikasi Flatpak..."
    if command -v flatpak >/dev/null 2>&1 && [ -f "$source_dir/flatpak_apps.txt" ]; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
        while IFS= read -r app_id; do
            [ -z "$app_id" ] && continue
            if ! flatpak info "$app_id" >/dev/null 2>&1; then
                echo "     Memasang: $app_id"
                flatpak install -y flathub "$app_id" 2>/dev/null || true
            fi
        done < "$source_dir/flatpak_apps.txt"
    fi

    # ─── 5. RESTORE NPM GLOBAL PACKAGES ───
    echo "  -> [5/6] Memulihkan NPM global packages..."
    if command -v npm >/dev/null 2>&1 && [ -f "$source_dir/npm_global.json" ]; then
        npm config set prefix "$HOME/.local" 2>/dev/null || true
        # Parse JSON dan install tiap package (skip npm sendiri)
        local pkgs
        pkgs=$(python3 -c "
import json, sys
try:
    data = json.load(open('$source_dir/npm_global.json'))
    deps = data.get('dependencies', {})
    for name in deps:
        if name != 'npm':
            print(name)
except: pass
" 2>/dev/null)
        if [ -n "$pkgs" ]; then
            while IFS= read -r pkg; do
                echo "     Memasang: $pkg"
                npm install -g "$pkg" 2>/dev/null || true
            done <<< "$pkgs"
        fi
    fi

    # ─── 6. SINKRONISASI SHELL PATH ───
    echo "  -> [6/6] Sinkronisasi PATH untuk semua shell aktif..."
    local path_line='export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.npm-global/bin:$PATH"'

    # Bash
    if [ -f "$HOME/.bashrc" ] && ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo "$path_line" >> "$HOME/.bashrc"
    fi

    # Zsh
    if [ -f "$HOME/.zshrc" ] && ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo "$path_line" >> "$HOME/.zshrc"
    fi

    # Fish
    if command -v fish >/dev/null 2>&1; then
        mkdir -p "$HOME/.config/fish"
        if ! grep -q 'fish_add_path' "$HOME/.config/fish/config.fish" 2>/dev/null; then
            echo 'fish_add_path ~/.local/bin ~/.bun/bin ~/.npm-global/bin' >> "$HOME/.config/fish/config.fish"
        fi
    fi

    echo "  [OK] Dependensi sistem, flatpak, npm globals, dan shell PATH tersinkronisasi."
}

# ─── HERMES AGENT AUTO-BOOTSTRAP ───
bootstrap_hermes() {
    local hermes_dir="$HOME/.hermes/hermes-agent"

    if [ ! -d "$hermes_dir" ]; then
        echo "  [SKIP] Hermes Agent tidak ditemukan di $hermes_dir"
        return 0
    fi

    if ! command -v uv >/dev/null 2>&1; then
        echo "  [WARN] UV tidak terinstall, skip Hermes bootstrap."
        return 0
    fi

    if [ ! -f "$hermes_dir/pyproject.toml" ] && [ ! -f "$hermes_dir/uv.lock" ]; then
        echo "  [SKIP] Tidak ditemukan pyproject.toml/uv.lock di Hermes."
        return 0
    fi

    echo "  -> Bootstrap ulang Hermes Agent environment dengan UV..."
    (
        cd "$hermes_dir" || return 1
        rm -rf venv
        uv venv venv
        uv sync
        # Install hermes ke PATH
        if [ -f "pyproject.toml" ]; then
            uv pip install -e . --python venv/bin/python 2>/dev/null || true
        fi
    )

    # Pastikan hermes binary linknya ada
    if [ -f "$hermes_dir/venv/bin/hermes" ] && [ ! -f "$HOME/.local/bin/hermes" ]; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$hermes_dir/venv/bin/hermes" "$HOME/.local/bin/hermes"
    fi

    echo "  [OK] Hermes Agent environment berhasil di-bootstrap."
}
