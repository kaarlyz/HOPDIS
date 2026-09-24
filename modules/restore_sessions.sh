#!/usr/bin/env bash
# Module: Complete Dynamic Sessions & Credentials Restorer

restore_all_sessions() {
    local bundle_dir="$1"

    echo "=== [2/3] MEMULIHKAN PROFILE BROWSER, CHAT, DEV KEYS & AI ENVIRONMENTS ==="

    # -------------------------------------------------------------
    # 1. RESTORE BROWSERS
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/browsers/firefox" ]; then
        echo "  -> Memulihkan sesi Firefox..."
        mkdir -p "$HOME/.mozilla/firefox"
        rsync -a "$bundle_dir/browsers/firefox/" "$HOME/.mozilla/firefox/"
    fi

    if [ -d "$bundle_dir/browsers/google-chrome" ]; then
        echo "  -> Memulihkan sesi Google Chrome..."
        mkdir -p "$HOME/.config/google-chrome"
        rsync -a "$bundle_dir/browsers/google-chrome/" "$HOME/.config/google-chrome/"
    fi

    if [ -d "$bundle_dir/browsers/brave" ]; then
        echo "  -> Memulihkan sesi Brave Browser..."
        mkdir -p "$HOME/.config/BraveSoftware/Brave-Browser"
        rsync -a "$bundle_dir/browsers/brave/" "$HOME/.config/BraveSoftware/Brave-Browser/"
    fi

    if [ -d "$bundle_dir/browsers/chromium" ]; then
        echo "  -> Memulihkan sesi Chromium..."
        mkdir -p "$HOME/.config/chromium"
        rsync -a "$bundle_dir/browsers/chromium/" "$HOME/.config/chromium/"
    fi

    if [ -d "$bundle_dir/browsers/librewolf" ]; then
        mkdir -p "$HOME/.librewolf"
        rsync -a "$bundle_dir/browsers/librewolf/" "$HOME/.librewolf/"
    fi

    # -------------------------------------------------------------
    # 2. RESTORE AI AGENTS & TOOLCHAINS
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/sessions/ai/hermes" ]; then
        echo "  -> Memulihkan Hermes Agent (config, memories, skills)..."
        mkdir -p "$HOME/.hermes"
        rsync -a "$bundle_dir/sessions/ai/hermes/" "$HOME/.hermes/"
    fi

    if [ -d "$bundle_dir/sessions/ai/9router" ]; then
        echo "  -> Memulihkan 9Router Gateway & Token DB..."
        mkdir -p "$HOME/.9router"
        rsync -a "$bundle_dir/sessions/ai/9router/" "$HOME/.9router/"
    fi

    if [ -d "$bundle_dir/sessions/ai/antigravity_config" ]; then
        echo "  -> Memulihkan Antigravity Config..."
        mkdir -p "$HOME/.config/antigravity"
        rsync -a "$bundle_dir/sessions/ai/antigravity_config/" "$HOME/.config/antigravity/"
    fi

    if [ -d "$bundle_dir/sessions/ai/antigravity_share" ]; then
        mkdir -p "$HOME/.local/share/antigravity"
        rsync -a "$bundle_dir/sessions/ai/antigravity_share/" "$HOME/.local/share/antigravity/"
    fi

    if [ -d "$bundle_dir/sessions/ai/opencode_config" ]; then
        echo "  -> Memulihkan OpenCode Config..."
        mkdir -p "$HOME/.config/opencode"
        rsync -a "$bundle_dir/sessions/ai/opencode_config/" "$HOME/.config/opencode/"
    fi

    if [ -d "$bundle_dir/sessions/ai/opencode_share" ]; then
        mkdir -p "$HOME/.local/share/opencode"
        rsync -a "$bundle_dir/sessions/ai/opencode_share/" "$HOME/.local/share/opencode/"
    fi

    if [ -d "$bundle_dir/sessions/ai/claude_config" ]; then
        mkdir -p "$HOME/.config/claude"
        rsync -a "$bundle_dir/sessions/ai/claude_config/" "$HOME/.config/claude/"
    fi

    if [ -d "$bundle_dir/sessions/ai/claude_code" ]; then
        mkdir -p "$HOME/.claude"
        rsync -a "$bundle_dir/sessions/ai/claude_code/" "$HOME/.claude/"
    fi

    if [ -d "$bundle_dir/sessions/ai/cursor" ]; then
        mkdir -p "$HOME/.config/Cursor"
        rsync -a "$bundle_dir/sessions/ai/cursor/" "$HOME/.config/Cursor/"
    fi

    # -------------------------------------------------------------
    # 3. RESTORE CHAT & SOCIAL (Zero-ReLogin)
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/sessions/chat/TelegramDesktop" ]; then
        echo "  -> Memulihkan sesi Telegram Desktop (Auto-Login)..."
        mkdir -p "$HOME/.local/share/TelegramDesktop"
        rsync -a "$bundle_dir/sessions/chat/TelegramDesktop/" "$HOME/.local/share/TelegramDesktop/"
    fi

    if [ -d "$bundle_dir/sessions/chat/discord" ]; then
        echo "  -> Memulihkan sesi Discord..."
        mkdir -p "$HOME/.config/discord"
        rsync -a "$bundle_dir/sessions/chat/discord/" "$HOME/.config/discord/"
    fi

    if [ -d "$bundle_dir/sessions/chat/whatsapp_linux" ]; then
        mkdir -p "$HOME/.config/whatsapp-for-linux"
        rsync -a "$bundle_dir/sessions/chat/whatsapp_linux/" "$HOME/.config/whatsapp-for-linux/"
    fi

    # -------------------------------------------------------------
    # 4. RESTORE DEV TOOLS, SSH, GIT & KEYRINGS
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/sessions/dev/ssh" ]; then
        echo "  -> Memulihkan SSH keys & konfigurasi keamanan..."
        mkdir -p "$HOME/.ssh"
        rsync -a "$bundle_dir/sessions/dev/ssh/" "$HOME/.ssh/"
        chmod 700 "$HOME/.ssh"
        chmod 600 "$HOME/.ssh/"* 2>/dev/null || true
        chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null || true
    fi

    if [ -f "$bundle_dir/sessions/dev/gitconfig" ]; then
        echo "  -> Memulihkan .gitconfig..."
        cp -a "$bundle_dir/sessions/dev/gitconfig" "$HOME/.gitconfig"
    fi

    if [ -d "$bundle_dir/sessions/dev/gh_cli" ]; then
        mkdir -p "$HOME/.config/gh"
        rsync -a "$bundle_dir/sessions/dev/gh_cli/" "$HOME/.config/gh/"
    fi

    if [ -d "$bundle_dir/sessions/dev/keyrings" ]; then
        echo "  -> Memulihkan Desktop Keyrings (Password Manager Vault)..."
        mkdir -p "$HOME/.local/share/keyrings"
        rsync -a "$bundle_dir/sessions/dev/keyrings/" "$HOME/.local/share/keyrings/"
        chmod 700 "$HOME/.local/share/keyrings"
    fi

    if [ -d "$bundle_dir/sessions/dev/docker" ]; then
        mkdir -p "$HOME/.docker"
        rsync -a "$bundle_dir/sessions/dev/docker/" "$HOME/.docker/"
    fi

    if [ -d "$bundle_dir/sessions/dev/ngrok" ]; then
        mkdir -p "$HOME/.config/ngrok"
        rsync -a "$bundle_dir/sessions/dev/ngrok/" "$HOME/.config/ngrok/"
    fi

    # -------------------------------------------------------------
    # 5. RESTORE DISCOVERED CONFIGS
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/sessions/discovered_configs" ]; then
        echo "  -> Memulihkan seluruh konfigurasi aplikasi aktif (~/.config)..."
        mkdir -p "$HOME/.config"
        rsync -a "$bundle_dir/sessions/discovered_configs/" "$HOME/.config/"
    fi

    # -------------------------------------------------------------
    # 6. RESTORE SYSTEMD USER SERVICES & LOCAL BINARIES
    # -------------------------------------------------------------
    if [ -d "$bundle_dir/sessions/system/local_bin" ]; then
        echo "  -> Memasang binary executable (~/.local/bin)..."
        mkdir -p "$HOME/.local/bin"
        rsync -a "$bundle_dir/sessions/system/local_bin/" "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
    fi

    if [ -d "$bundle_dir/sessions/system/shell" ]; then
        echo "  -> Memulihkan Shell dotfiles..."
        cp -a "$bundle_dir/sessions/system/shell/"* "$HOME/" 2>/dev/null || true
    fi

    if [ -d "$bundle_dir/sessions/system/systemd_user" ]; then
        echo "  -> Mengonfigurasi & mengaktifkan ulang systemd user services..."
        mkdir -p "$HOME/.config/systemd/user"
        rsync -a "$bundle_dir/sessions/system/systemd_user/" "$HOME/.config/systemd/user/"
        systemctl --user daemon-reload 2>/dev/null || true
        for s in "$HOME/.config/systemd/user/"*.service; do
            if [ -f "$s" ]; then
                local sname
                sname="$(basename "$s")"
                systemctl --user enable --now "$sname" 2>/dev/null || true
                echo "     [Service Enabled] $sname"
            fi
        done
    fi

    echo "=== [3/3] MEMPERBAIKI USER OWNERSHIP & PERMISSIONS ==="
    chown -R "$USER:$USER" "$HOME/.hermes" "$HOME/.9router" "$HOME/.config" "$HOME/.local" "$HOME/.ssh" 2>/dev/null || true

    echo "  [SELESAI] Seluruh environment, auth, dan AI agents siap dipakai seketika."
}
