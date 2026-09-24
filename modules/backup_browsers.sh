#!/usr/bin/env bash
# Module: Browser Profiles & Sessions Exporter with Cache Exclusion

export_browsers() {
    local target_dir="$1/browsers"
    mkdir -p "$target_dir"

    echo "  -> Memindai profile & login session browser (tanpa cache sampah)..."

    # Chromium-based (Chrome, Brave, Chromium, Edge, Vivaldi)
    local chrome_dirs=(
        "$HOME/.config/google-chrome"
        "$HOME/.config/BraveSoftware/Brave-Browser"
        "$HOME/.config/chromium"
        "$HOME/.config/microsoft-edge"
        "$HOME/.config/vivaldi"
    )

    for cdir in "${chrome_dirs[@]}"; do
        if [ -d "$cdir" ]; then
            local bname="$(basename "$cdir")"
            echo "     - Ditemukan: $bname"
            mkdir -p "$target_dir/$bname"
            rsync -a --delete \
                --exclude="Cache" \
                --exclude="Code Cache" \
                --exclude="GPUCache" \
                --exclude="Service Worker/CacheStorage" \
                --exclude="GrShaderCache" \
                --exclude="ShaderCache" \
                --exclude="*.tmp" \
                "$cdir/" "$target_dir/$bname/" 2>/dev/null || cp -r "$cdir" "$target_dir/$bname"
        fi
    done

    # Firefox / LibreWolf
    if [ -d "$HOME/.mozilla/firefox" ]; then
        echo "     - Ditemukan: Mozilla Firefox"
        mkdir -p "$target_dir/firefox"
        rsync -a --delete \
            --exclude="cache2" \
            --exclude="startupCache" \
            --exclude="shader-cache" \
            --exclude="jumpListCache" \
            --exclude="*.tmp" \
            "$HOME/.mozilla/firefox/" "$target_dir/firefox/" 2>/dev/null || cp -r "$HOME/.mozilla/firefox" "$target_dir/"
    fi

    if [ -d "$HOME/.librewolf" ]; then
        echo "     - Ditemukan: LibreWolf"
        mkdir -p "$target_dir/librewolf"
        rsync -a --delete \
            --exclude="cache2" \
            --exclude="startupCache" \
            "$HOME/.librewolf/" "$target_dir/librewolf/" 2>/dev/null || cp -r "$HOME/.librewolf" "$target_dir/"
    fi

    echo "  [OK] Profile browser berhasil disalin."
}
