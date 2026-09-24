#!/usr/bin/env bash
# Module: Universal Auto-Discovery & Dynamic State Exporter

export_all_discovered_sessions() {
    local target_dir="$1/sessions"
    mkdir -p "$target_dir"

    echo "=== [1/2] AUDIT & AUTO-DISCOVERY SYSTEM SESSIONS ==="

    # -------------------------------------------------------------
    # 1. AI AGENTS, ASSISTANTS & GATEWAYS
    # -------------------------------------------------------------
    local ai_targets=(
        "hermes:$HOME/.hermes"
        "9router:$HOME/.9router"
        "opencode_config:$HOME/.config/opencode"
        "opencode_share:$HOME/.local/share/opencode"
        "antigravity_config:$HOME/.config/antigravity"
        "antigravity_share:$HOME/.local/share/antigravity"
        "claude_config:$HOME/.config/claude"
        "claude_code:$HOME/.claude"
        "codex:$HOME/.codex"
        "cursor:$HOME/.config/Cursor"
        "continue:$HOME/.continue"
        "ollama:$HOME/.ollama"
        "lmstudio:$HOME/.cache/lm-studio"
    )

    for item in "${ai_targets[@]}"; do
        local name="${item%%:*}"
        local path="${item##*:}"
        if [ -d "$path" ] || [ -f "$path" ]; then
            echo "  [FOUND: AI Agent] $name -> $path"
            mkdir -p "$target_dir/ai/$name"
            rsync -a --exclude="cache/*" --exclude="audio_cache/*" --exclude="sandbox_cache/*" --exclude="logs/*" \
                "$path" "$target_dir/ai/$name/" 2>/dev/null || true
        fi
    done

    # -------------------------------------------------------------
    # 2. CHAT, SOCIAL & COMMUNICATION (Zero-ReLogin)
    # -------------------------------------------------------------
    local chat_targets=(
        "TelegramDesktop:$HOME/.local/share/TelegramDesktop/tdata"
        "discord:$HOME/.config/discord"
        "betterdiscord:$HOME/.config/BetterDiscord"
        "whatsapp_linux:$HOME/.config/whatsapp-for-linux"
        "slack:$HOME/.config/Slack"
        "element:$HOME/.config/Element"
        "signal:$HOME/.config/Signal"
        "teams:$HOME/.config/teams-for-linux"
        "thunderbird:$HOME/.thunderbird"
    )

    for item in "${chat_targets[@]}"; do
        local name="${item%%:*}"
        local path="${item##*:}"
        if [ -d "$path" ] || [ -f "$path" ]; then
            echo "  [FOUND: Chat/Comms] $name -> $path"
            mkdir -p "$target_dir/chat/$name"
            rsync -a --exclude="*cache*" --exclude="*Cache*" --exclude="GPUCache" "$path" "$target_dir/chat/$name/" 2>/dev/null || true
        fi
    done

    # -------------------------------------------------------------
    # 3. DEV TOOLS, CLOUD, KREDENSIAL & KEYS
    # -------------------------------------------------------------
    local dev_targets=(
        "ssh:$HOME/.ssh"
        "gitconfig:$HOME/.gitconfig"
        "gh_cli:$HOME/.config/gh"
        "gnupg:$HOME/.gnupg"
        "keyrings:$HOME/.local/share/keyrings"
        "pki:$HOME/.local/share/pki"
        "aws:$HOME/.aws"
        "docker:$HOME/.docker"
        "gcloud:$HOME/.config/gcloud"
        "kube:$HOME/.kube"
        "ngrok:$HOME/.config/ngrok"
        "cloudflared:$HOME/.cloudflared"
        "postman:$HOME/.config/Postman"
        "insomnia:$HOME/.config/Insomnia"
        "dbeaver:$HOME/.local/share/DBeaverData"
    )

    for item in "${dev_targets[@]}"; do
        local name="${item%%:*}"
        local path="${item##*:}"
        if [ -d "$path" ] || [ -f "$path" ]; then
            echo "  [FOUND: Dev/Auth] $name -> $path"
            mkdir -p "$target_dir/dev/$name"
            rsync -a "$path" "$target_dir/dev/$name/" 2>/dev/null || true
        fi
    done

    # -------------------------------------------------------------
    # 4. SYSTEM SERVICES, BINARIES & DOTFILES
    # -------------------------------------------------------------
    mkdir -p "$target_dir/system"
    if [ -d "$HOME/.config/systemd/user" ]; then
        echo "  [FOUND: Systemd Services] User daemons"
        mkdir -p "$target_dir/system/systemd_user"
        rsync -a "$HOME/.config/systemd/user/" "$target_dir/system/systemd_user/" 2>/dev/null || true
    fi

    if [ -d "$HOME/.local/bin" ]; then
        echo "  [FOUND: Local Binaries] User scripts & binaries"
        mkdir -p "$target_dir/system/local_bin"
        rsync -a "$HOME/.local/bin/" "$target_dir/system/local_bin/" 2>/dev/null || true
    fi

    # Shell RC & Environment
    mkdir -p "$target_dir/system/shell"
    for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.bash_profile" "$HOME/.zshenv" "$HOME/.config/fish"; do
        if [ -e "$f" ]; then
            echo "  [FOUND: Shell Config] $(basename "$f")"
            cp -a "$f" "$target_dir/system/shell/" 2>/dev/null || true
        fi
    done

    # -------------------------------------------------------------
    # 5. DYNAMIC SCANNER (Cari Kredensial & Config Tersembunyi Lain)
    # -------------------------------------------------------------
    echo "  -> Menjalankan deep audit di ~/.config dan ~/.local/share untuk konfigurasi aktif..."
    mkdir -p "$target_dir/discovered_configs"
    find "$HOME/.config" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | while read -r d; do
        bname="$(basename "$d")"
        case "$bname" in
            google-chrome|BraveSoftware|chromium|microsoft-edge|vivaldi|discord|opencode|systemd|gh|ngrok)
                # Sudah di-handle modul khusus
                ;;
            *)
                # Backup folder config aktif (kecuali cache berat)
                rsync -a --exclude="*cache*" --exclude="*Cache*" --exclude="logs" "$d" "$target_dir/discovered_configs/" 2>/dev/null || true
                ;;
        esac
    done

    echo "  [OK] Seluruh data & sesi sistem berhasil diaudit dan dicadangkan."
}
