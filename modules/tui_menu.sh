#!/usr/bin/env bash
# Module: Interactive TUI Menu Selector for HOPDIS

select_backup_components() {
    # If whiptail is available and interactive terminal
    if command -v whiptail >/dev/null 2>&1 && [ -t 0 ]; then
        local choices
        choices=$(whiptail --title "HOPDIS — Pilih Komponen Backup" \
            --checklist "Gunakan SPACE untuk memilih/membatalkan, ENTER untuk konfirmasi:" 18 70 6 \
            "PACKAGES" "Daftar Software & Manifest (APT/Pacman/Flatpak)" ON \
            "BROWSERS" "Sesi & Profile Browser (Chrome/Brave/Firefox)" ON \
            "CHAT"     "Sesi Chat & Messenger (Telegram tdata/Discord)" ON \
            "AI_STACK" "AI Agents & Gateway (Hermes/9Router/Antigravity)" ON \
            "DEV_KEYS" "SSH Keys, Git Config, GPG & Keyrings Vault" ON \
            "DESKTOP"  "Systemd Services, Scripts bin & Shell Dotfiles" ON \
            3>&1 1>&2 2>&3)

        if [ $? -ne 0 ]; then
            echo "Backup dibatalkan oleh pengguna."
            exit 0
        fi
        echo "$choices"
    else
        # Non-interactive / headless fallback: select all
        echo '"PACKAGES" "BROWSERS" "CHAT" "AI_STACK" "DEV_KEYS" "DESKTOP"'
    fi
}
