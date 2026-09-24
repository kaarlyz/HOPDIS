#!/usr/bin/env bash
# Module: Interactive Cloud Storage Integration (Google Drive / OneDrive / Mega)

setup_rclone_remote() {
    local C_RESET="\033[0m"
    local C_BOLD="\033[1m"
    local C_GREEN="\033[38;2;152;195;121m"
    local C_CYAN="\033[38;2;86;182;194m"

    echo -e "${C_CYAN}${C_BOLD}▶ Membuka Setup Wizard Cloud Storage (Rclone)...${C_RESET}"
    if ! command -v rclone >/dev/null 2>&1; then
        echo "  -> Memasang rclone CLI..."
        sudo apt-get install -y rclone 2>/dev/null || sudo pacman -S --noconfirm rclone 2>/dev/null || sudo dnf install -y rclone 2>/dev/null || true
    fi
    rclone config
}

interactive_cloud_menu() {
    local C_RESET="\033[0m"
    local C_BOLD="\033[1m"
    local C_GREEN="\033[38;2;152;195;121m"
    local C_YELLOW="\033[38;2;229;192;123m"
    local C_CYAN="\033[38;2;86;182;194m"
    local C_RED="\033[38;2;224;108;117m"

    if ! command -v rclone >/dev/null 2>&1; then
        echo -e "${C_CYAN}▶ Memasang rclone CLI ke sistem...${C_RESET}"
        sudo apt-get install -y rclone 2>/dev/null || sudo pacman -S --noconfirm rclone 2>/dev/null || sudo dnf install -y rclone 2>/dev/null || true
    fi

    # Check available remotes
    local remotes
    remotes="$(rclone listremotes 2>/dev/null || true)"

    if [ -z "$remotes" ]; then
        if command -v whiptail >/dev/null 2>&1 && [ -t 0 ]; then
            if whiptail --title "HOPDIS — Cloud Storage" --yesno "Belum ada akun Cloud Storage (Google Drive / OneDrive) yang terhubung.\n\nApakah Anda ingin menghubungkan akun Google Drive sekarang?" 12 65; then
                setup_rclone_remote
                remotes="$(rclone listremotes 2>/dev/null || true)"
            else
                return 0
            fi
        else
            echo -e "${C_YELLOW}⚠ Belum ada remote cloud. Jalankan setup rclone...${C_RESET}"
            setup_rclone_remote
            remotes="$(rclone listremotes 2>/dev/null || true)"
        fi
    fi

    if [ -z "$remotes" ]; then
        echo -e "${C_RED}✖ Tidak ada akun cloud yang terhubung.${C_RESET}"
        return 0
    fi

    # Whiptail Menu Selector for Cloud Actions
    if command -v whiptail >/dev/null 2>&1 && [ -t 0 ]; then
        local action
        action=$(whiptail --title "HOPDIS — Menu Cloud Storage" \
            --menu "Pilih aksi Cloud Storage yang ingin dilakukan:" 16 70 4 \
            "UPLOAD"   "Unggah file backup lokal ke Cloud Storage (Google Drive)" \
            "DOWNLOAD" "Unduh file backup dari Cloud Storage ke komputer ini" \
            "CONFIG"   "Tambah / Ubah akun Cloud Storage (Rclone Wizard)" \
            3>&1 1>&2 2>&3)

        case "$action" in
            UPLOAD)
                local backup_file
                backup_file="$(find "$SCRIPT_DIR" -maxdepth 1 -name "distrohop_backup_*.tar.*" -o -name "hopdis_windows_migration_*.zip" 2>/dev/null | sort -r | head -n 1)"
                if [ -z "$backup_file" ]; then
                    whiptail --title "Error" --msgbox "Tidak ditemukan file backup di folder saat ini." 10 50
                    return 1
                fi

                # Select remote
                local remote_list=()
                for r in $remotes; do
                    remote_list+=("$r" "Cloud Remote Target")
                done
                local selected_remote
                selected_remote=$(whiptail --title "Pilih Cloud Remote" --menu "Pilih akun cloud tujuan:" 14 60 4 "${remote_list[@]}" 3>&1 1>&2 2>&3)

                if [ -n "$selected_remote" ]; then
                    echo -e "${C_CYAN}▶ Mengunggah $(basename "$backup_file") ke ${selected_remote}HOPDIS_Backups...${C_RESET}"
                    rclone copy --progress "$backup_file" "${selected_remote}HOPDIS_Backups/"
                    whiptail --title "Sukses" --msgbox "File backup berhasil diunggah ke ${selected_remote}HOPDIS_Backups!" 10 60
                fi
                ;;

            DOWNLOAD)
                local remote_list=()
                for r in $remotes; do
                    remote_list+=("$r" "Cloud Remote Source")
                done
                local selected_remote
                selected_remote=$(whiptail --title "Pilih Cloud Remote" --menu "Pilih akun cloud sumber:" 14 60 4 "${remote_list[@]}" 3>&1 1>&2 2>&3)

                if [ -n "$selected_remote" ]; then
                    echo -e "${C_CYAN}▶ Mengunduh daftar backup dari ${selected_remote}HOPDIS_Backups...${C_RESET}"
                    rclone copy --progress "${selected_remote}HOPDIS_Backups/" "$SCRIPT_DIR/"
                    whiptail --title "Sukses" --msgbox "File backup berhasil diunduh ke folder kerja lokal!" 10 60
                fi
                ;;

            CONFIG)
                setup_rclone_remote
                ;;
        esac
    fi
}
