#!/usr/bin/env bash
# Module: Modern TUI Menu Selector for HOPDIS

select_backup_components() {
    if command -v whiptail >/dev/null 2>&1 && [ -t 0 ]; then
        local choices
        choices=$(whiptail --title "🚀 HOPDIS — PILIH KOMPONEN CADANGAN" \
            --checklist "Gunakan SPACE untuk memilih modul, ENTER untuk melanjutkan:" 18 72 6 \
            "PACKAGES" "Daftar Software & Manifest (APT/Pacman/Flatpak/NPM)" ON \
            "BROWSERS" "Sesi & Profil Browser (Chrome/Brave/Firefox/Cookies)" ON \
            "CHAT"     "Sesi Pesan & Chat (Telegram tdata/Discord/Whatsie)" ON \
            "AI_STACK" "AI Agents & Gateway (Hermes/9Router/Antigravity/OpenCode)" ON \
            "DEV_KEYS" "Kunci SSH, Git Config, GPG, VSCode & Keyrings Vault" ON \
            "DESKTOP"  "Systemd User Services, Scripts ~/.local/bin & Dotfiles" ON \
            3>&1 1>&2 2>&3)

        if [ $? -ne 0 ]; then
            echo -e "\n\033[38;2;224;108;117m✖ Proses cadangan dibatalkan oleh pengguna.\033[0m\n"
            exit 0
        fi
        echo "$choices"
    else
        echo '"PACKAGES" "BROWSERS" "CHAT" "AI_STACK" "DEV_KEYS" "DESKTOP"'
    fi
}
