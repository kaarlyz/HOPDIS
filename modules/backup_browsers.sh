#!/usr/bin/env bash
# Module: Browser Profiles & Sessions Exporter

export_browsers() {
    local target_dir="$1/browsers"
    mkdir -p "$target_dir"

    echo "  -> Memindai profile & login session browser..."

    # 1. Firefox & Librewolf
    if [ -d "$HOME/.mozilla/firefox" ]; then
        echo "     - Ditemukan: Mozilla Firefox"
        mkdir -p "$target_dir/firefox"
        rsync -a --exclude="cache2" --exclude="jumpListCache" --exclude="startupCache" \
            "$HOME/.mozilla/firefox/" "$target_dir/firefox/" 2>/dev/null || true
    fi

    if [ -d "$HOME/.librewolf" ]; then
        echo "     - Ditemukan: LibreWolf"
        mkdir -p "$target_dir/librewolf"
        rsync -a --exclude="cache2" "$HOME/.librewolf/" "$target_dir/librewolf/" 2>/dev/null || true
    fi

    # 2. Chromium-based browsers (Google Chrome, Brave, Chromium, Edge, Vivaldi)
    local chromium_paths=(
        "google-chrome:$HOME/.config/google-chrome"
        "brave:$HOME/.config/BraveSoftware/Brave-Browser"
        "chromium:$HOME/.config/chromium"
        "microsoft-edge:$HOME/.config/microsoft-edge"
        "vivaldi:$HOME/.config/vivaldi"
    )

    for item in "${chromium_paths[@]}"; do
        local name="${item%%:*}"
        local path="${item##*:}"
        if [ -d "$path" ]; then
            echo "     - Ditemukan: $name"
            mkdir -p "$target_dir/$name"
            # Exclude cache berat tapi simpan data login, cookies, profile, extensions
            rsync -a \
                --exclude="*/Cache/*" \
                --exclude="*/Code Cache/*" \
                --exclude="*/GPUCache/*" \
                --exclude="*/Service Worker/CacheStorage/*" \
                --exclude="*/GrShaderCache/*" \
                "$path/" "$target_dir/$name/" 2>/dev/null || true
        fi
    done

    echo "  [OK] Profile browser berhasil disalin."
}
