#!/usr/bin/env bash

install_manifests() {
    local source_dir="$1/manifests"
    local family="$2"

    echo "=== [1/3] MEMERIKSA & MENGINSTALL RUNTIME, TOOLCHAIN & PACKAGES ==="
    case "$family" in
        arch)
            sudo pacman -Sy --needed --noconfirm curl wget git rsync zstd python python-yaml python-dotenv nodejs npm flatpak base-devel bun uv || true
            ;;
    esac

    # Bersihkan wrapper lokal yang korup
    if [ -f "/usr/bin/npm" ] && [ -f "$HOME/.local/bin/npm" ]; then
        rm -f "$HOME/.local/bin/npm"
    fi

    # Sinkronisasi Fish Shell
    if command -v fish >/dev/null; then
        mkdir -p "$HOME/.config/fish"
        fish -c "fish_add_path $HOME/.local/bin $HOME/.npm-global/bin" || true
    fi

    # Auto-Provisioning Hermes
    if [ -d "$HOME/.hermes/hermes-agent" ] && command -v uv >/dev/null; then
        echo "  -> Bootstrap ulang Hermes environment dengan UV..."
        (cd "$HOME/.hermes/hermes-agent" && rm -rf venv && uv venv venv && uv sync) || true
    fi
}
