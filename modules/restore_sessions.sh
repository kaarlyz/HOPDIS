#!/usr/bin/env bash
# Module: Complete Dynamic Sessions & Credentials Restorer

restore_all_sessions() {
    local bundle_dir="$1"

    echo "=== [2/3] MEMULIHKAN PROFILE BROWSER, CHAT, DEV KEYS & AI STACK ==="

    # 1. RESTORE BROWSERS
    if [ -d "$bundle_dir/browsers" ]; then
        echo "  -> Memulihkan sesi browser..."
        # Chromium-based
        for bpath in "$bundle_dir/browsers"/*; do
            [ ! -d "$bpath" ] && continue
            local bname="$(basename "$bpath")"
            if [ "$bname" = "google-chrome" ]; then
                mkdir -p "$HOME/.config/google-chrome"
                rsync -a "$bpath/" "$HOME/.config/google-chrome/"
            elif [ "$bname" = "Brave-Browser" ]; then
                mkdir -p "$HOME/.config/BraveSoftware/Brave-Browser"
                rsync -a "$bpath/" "$HOME/.config/BraveSoftware/Brave-Browser/"
            elif [ "$bname" = "chromium" ]; then
                mkdir -p "$HOME/.config/chromium"
                rsync -a "$bpath/" "$HOME/.config/chromium/"
            fi
        done

        # Firefox
        if [ -d "$bundle_dir/browsers/firefox" ]; then
            mkdir -p "$HOME/.mozilla/firefox"
            rsync -a "$bundle_dir/browsers/firefox/" "$HOME/.mozilla/firefox/"
        fi
    fi

    # 2. RESTORE AI STACK
    if [ -d "$bundle_dir/sessions/ai" ]; then
        echo "  -> Memulihkan stack AI Agents (Hermes, 9Router, Antigravity, OpenCode)..."
        [ -d "$bundle_dir/sessions/ai/hermes" ] && rsync -a "$bundle_dir/sessions/ai/hermes/.hermes/" "$HOME/.hermes/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/9router" ] && rsync -a "$bundle_dir/sessions/ai/9router/.9router/" "$HOME/.9router/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/opencode_config" ] && rsync -a "$bundle_dir/sessions/ai/opencode_config/opencode/" "$HOME/.config/opencode/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/opencode_share" ] && rsync -a "$bundle_dir/sessions/ai/opencode_share/opencode/" "$HOME/.local/share/opencode/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/opencode_dot" ] && rsync -a "$bundle_dir/sessions/ai/opencode_dot/.opencode/" "$HOME/.opencode/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/antigravity_config" ] && rsync -a "$bundle_dir/sessions/ai/antigravity_config/antigravity/" "$HOME/.config/antigravity/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/antigravity_share" ] && rsync -a "$bundle_dir/sessions/ai/antigravity_share/antigravity/" "$HOME/.local/share/antigravity/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/copilot" ] && rsync -a "$bundle_dir/sessions/ai/copilot/.copilot/" "$HOME/.copilot/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/gemini" ] && rsync -a "$bundle_dir/sessions/ai/gemini/.gemini/" "$HOME/.gemini/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/tv_mcp" ] && rsync -a "$bundle_dir/sessions/ai/tv_mcp/.tv-mcp/" "$HOME/.tv-mcp/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/ai/cua_driver" ] && rsync -a "$bundle_dir/sessions/ai/cua_driver/.cua-driver/" "$HOME/.cua-driver/" 2>/dev/null || true
    fi

    # 3. RESTORE CHAT & MESSENGERS (Zero-ReLogin)
    if [ -d "$bundle_dir/sessions/chat" ]; then
        echo "  -> Memulihkan sesi chat & messenger..."
        if [ -d "$bundle_dir/sessions/chat/TelegramDesktop" ]; then
            mkdir -p "$HOME/.local/share/TelegramDesktop"
            rsync -a "$bundle_dir/sessions/chat/TelegramDesktop/tdata" "$HOME/.local/share/TelegramDesktop/"
        fi
        [ -d "$bundle_dir/sessions/chat/discord" ] && rsync -a "$bundle_dir/sessions/chat/discord/discord/" "$HOME/.config/discord/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/chat/whatsie" ] && rsync -a "$bundle_dir/sessions/chat/whatsie/" "$HOME/.var/app/com.ktechpit.whatsie/" 2>/dev/null || true
    fi

    # 4. RESTORE DEV TOOLS, SSH, GIT & KEYS
    if [ -d "$bundle_dir/sessions/dev" ]; then
        echo "  -> Memulihkan kunci SSH, Git config, dan VSCode extensions..."
        if [ -d "$bundle_dir/sessions/dev/ssh" ]; then
            mkdir -p "$HOME/.ssh"
            rsync -a "$bundle_dir/sessions/dev/ssh/.ssh/" "$HOME/.ssh/" 2>/dev/null || rsync -a "$bundle_dir/sessions/dev/ssh/" "$HOME/.ssh/"
            chmod 700 "$HOME/.ssh"
            chmod 600 "$HOME/.ssh"/* 2>/dev/null || true
            chmod 644 "$HOME/.ssh"/*.pub 2>/dev/null || true
        fi
        [ -f "$bundle_dir/sessions/dev/gitconfig/.gitconfig" ] && cp -a "$bundle_dir/sessions/dev/gitconfig/.gitconfig" "$HOME/.gitconfig"
        [ -f "$bundle_dir/sessions/dev/gitconfig" ] && cp -a "$bundle_dir/sessions/dev/gitconfig" "$HOME/.gitconfig"
        [ -d "$bundle_dir/sessions/dev/bun" ] && rsync -a "$bundle_dir/sessions/dev/bun/.bun/" "$HOME/.bun/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/dev/vscode_dot" ] && rsync -a "$bundle_dir/sessions/dev/vscode_dot/.vscode/" "$HOME/.vscode/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/dev/vscode_shared" ] && rsync -a "$bundle_dir/sessions/dev/vscode_shared/.vscode-shared/" "$HOME/.vscode-shared/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/dev/tradingview_config" ] && rsync -a "$bundle_dir/sessions/dev/tradingview_config/TradingView/" "$HOME/.config/TradingView/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/dev/keyrings" ] && rsync -a "$bundle_dir/sessions/dev/keyrings/keyrings/" "$HOME/.local/share/keyrings/" 2>/dev/null || true
        [ -d "$bundle_dir/sessions/dev/pki" ] && rsync -a "$bundle_dir/sessions/dev/pki/pki/" "$HOME/.local/share/pki/" 2>/dev/null || true
    fi

    # 5. RESTORE SYSTEMD USER SERVICES & BINARIES
    if [ -d "$bundle_dir/sessions/system" ]; then
        echo "  -> Memulihkan binary scripts dan systemd user services..."
        if [ -d "$bundle_dir/sessions/system/local_bin" ]; then
            mkdir -p "$HOME/.local/bin"
            rsync -a "$bundle_dir/sessions/system/local_bin/" "$HOME/.local/bin/"
            chmod +x "$HOME/.local/bin"/* 2>/dev/null || true
        fi

        if [ -d "$bundle_dir/sessions/system/systemd_user" ]; then
            mkdir -p "$HOME/.config/systemd/user"
            rsync -a "$bundle_dir/sessions/system/systemd_user/" "$HOME/.config/systemd/user/"
            systemctl --user daemon-reload 2>/dev/null || true
            for s in "$HOME/.config/systemd/user"/*.service; do
                if [ -f "$s" ]; then
                    local sname="$(basename "$s")"
                    systemctl --user enable --now "$sname" 2>/dev/null || true
                fi
            done
        fi
    fi

    # 6. RESTORE DISCOVERED CONFIGS
    if [ -d "$bundle_dir/sessions/discovered_configs" ]; then
        mkdir -p "$HOME/.config"
        rsync -a "$bundle_dir/sessions/discovered_configs/" "$HOME/.config/" 2>/dev/null || true
    fi

    echo "  [OK] Seluruh data & sesi sistem telah berhasil dipulihkan."
}
