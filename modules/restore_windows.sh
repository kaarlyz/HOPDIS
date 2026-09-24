#!/usr/bin/env bash
# Module: Windows-to-Linux Importer and Software Alternative Mapper

map_windows_alternatives() {
    local manifest_file="$1"
    local family="$2"
    local pkg_mgr="$3"

    echo "=== [WINDOWS MIGRATION] MENGANALISIS & MEMASANG ALTERNATIF SOFTWARE ==="

    if [ ! -f "$manifest_file" ]; then
        return 0
    fi

    # Check for flatpak availability
    local has_flatpak=false
    command -v flatpak >/dev/null 2>&1 && has_flatpak=true

    # Map Windows Apps to Linux Alternatives
    while IFS= read -r app_name; do
        [ -z "$app_name" ] && continue

        case "$app_name" in
            *"Microsoft Office"*|*"Word"*|*"Excel"*)
                echo "  -> Terdeteksi: Microsoft Office -> Pasang alternatif Linux: LibreOffice"
                if [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y libreoffice libreoffice-gtk3 2>/dev/null || true
                elif [ "$pkg_mgr" = "pacman" ]; then
                    sudo pacman -S --noconfirm libreoffice-fresh 2>/dev/null || true
                elif [ "$pkg_mgr" = "dnf" ]; then
                    sudo dnf install -y libreoffice 2>/dev/null || true
                fi
                ;;
            *"Visual Studio Code"*|*"VSCode"*)
                echo "  -> Terdeteksi: VS Code -> Menyiapkan VS Code di Linux..."
                if [ "$has_flatpak" = true ]; then
                    flatpak install -y flathub com.visualstudio.code 2>/dev/null || true
                fi
                ;;
            *"Discord"*)
                echo "  -> Terdeteksi: Discord -> Memasang Discord Linux..."
                if [ "$has_flatpak" = true ]; then
                    flatpak install -y flathub com.discordapp.Discord 2>/dev/null || true
                elif [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y discord 2>/dev/null || true
                fi
                ;;
            *"Telegram"*)
                echo "  -> Terdeteksi: Telegram Desktop -> Memasang Telegram Linux..."
                if [ "$has_flatpak" = true ]; then
                    flatpak install -y flathub org.telegram.desktop 2>/dev/null || true
                elif [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y telegram-desktop 2>/dev/null || true
                fi
                ;;
            *"Steam"*)
                echo "  -> Terdeteksi: Steam Gaming -> Memasang Steam + Proton compatibility..."
                if [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y steam-installer 2>/dev/null || true
                elif [ "$pkg_mgr" = "pacman" ]; then
                    sudo pacman -S --noconfirm steam 2>/dev/null || true
                fi
                ;;
            *"Notepad++"*)
                echo "  -> Terdeteksi: Notepad++ -> Pasang editor teks modern (Kate / Notepad Next)..."
                if [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y kate 2>/dev/null || true
                fi
                ;;
            *"VLC"*)
                echo "  -> Terdeteksi: VLC Media Player -> Memasang VLC Linux..."
                if [ "$pkg_mgr" = "apt" ]; then
                    sudo apt-get install -y vlc 2>/dev/null || true
                elif [ "$pkg_mgr" = "pacman" ]; then
                    sudo pacman -S --noconfirm vlc 2>/dev/null || true
                fi
                ;;
        esac
    done < "$manifest_file"

    echo "  [OK] Pemetaan software alternatif selesai."
}
