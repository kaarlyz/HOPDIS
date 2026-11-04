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
    bootstrap_hermes
    bootstrap_9router
}

# ─── 9ROUTER GATEWAY AUTO-INSTALL ───
bootstrap_9router() {
    local has_9router=false
    if [ -f "$source_dir/ai_cli_tools.txt" ] && grep -q "^9router$" "$source_dir/ai_cli_tools.txt" 2>/dev/null; then
        has_9router=true
    elif [ -d "$HOME/.9router" ] || [ -f "$HOME/.config/systemd/user/9router.service" ]; then
        has_9router=true
    fi

    if [ "$has_9router" = true ]; then
        if ! command -v 9router >/dev/null 2>&1; then
            echo "  -> 9Router terdeteksi. Menginstall binary 9router via npm..."
            sudo npm install -g 9router 2>/dev/null || npm install -g --prefix "$HOME/.local" 9router 2>/dev/null || true
        fi

        # Validasi path di 9router.service
        local s_file="$HOME/.config/systemd/user/9router.service"
        if [ -f "$s_file" ]; then
            local real_cli=""
            if [ -f "/usr/lib/node_modules/9router/cli.js" ]; then
                real_cli="/usr/lib/node_modules/9router/cli.js"
            elif [ -f "$HOME/.local/lib/node_modules/9router/cli.js" ]; then
                real_cli="$HOME/.local/lib/node_modules/9router/cli.js"
            elif command -v 9router >/dev/null 2>&1; then
                real_cli="$(command -v 9router)"
            fi

            if [ -n "$real_cli" ] && ! grep -q "$real_cli" "$s_file"; then
                sed -i "s|/usr/lib/node_modules/9router/cli.js|$real_cli|g" "$s_file" 2>/dev/null || true
            fi
        fi
        echo "  [OK] 9Router Gateway siap & tervalidasi."
    fi
}

# ─── HERMES AGENT AUTO-BOOTSTRAP ───
bootstrap_hermes() {
    local hermes_dir="$HOME/hermes-agent"
    [ ! -d "$hermes_dir" ] && hermes_dir="$HOME/.hermes/hermes-agent"

    if [ ! -d "$hermes_dir" ]; then
        echo "  [SKIP] Hermes Agent tidak ditemukan di $hermes_dir"
        return 0
    fi

    if ! command -v uv >/dev/null 2>&1; then
        echo "  [WARN] UV tidak terinstall, skip Hermes bootstrap."
        return 0
    fi

    echo "  -> Bootstrap ulang Hermes Agent environment dengan UV..."
    (
        cd "$hermes_dir" || return 1
        # Bersihkan venv lama agar tidak crash akibat beda versi python/glibc
        rm -rf venv
        uv venv venv
        uv sync 2>/dev/null || true
        # Install hermes ke PATH
        if [ -f "pyproject.toml" ]; then
            uv pip install -e . --python venv/bin/python 2>/dev/null || true
        fi
    )

    # Pastikan hermes wrapper selalu valid dan point ke target path yang benar
    mkdir -p "$HOME/.local/bin"
    if [ -f "$hermes_dir/.hermes/bin/hermes" ]; then
        cat <<EOF > "$HOME/.local/bin/hermes"
#!/bin/sh
exec "$hermes_dir/.hermes/bin/hermes" "\$@"
EOF
        chmod +x "$HOME/.local/bin/hermes"
    elif [ -f "$hermes_dir/venv/bin/hermes" ]; then
        cat <<EOF > "$HOME/.local/bin/hermes"
#!/bin/sh
exec "$hermes_dir/venv/bin/hermes" "\$@"
EOF
        chmod +x "$HOME/.local/bin/hermes"
    fi

    echo "  [OK] Hermes Agent environment berhasil di-bootstrap."
}
