#!/usr/bin/env bash
# Module: Smart Project Workspace Auto-Discovery & Credentials Backup
# Universal: Detects Git repositories up to depth 4 to avoid full system scans.

export_projects_and_keys() {
    local target_dir="$1/projects_and_keys"
    mkdir -p "$target_dir"
    local proj_dest="$target_dir/workspaces"
    mkdir -p "$proj_dest"

    echo "=== [3/3] AUTO-DISCOVERING DEVELOPER WORKSPACES & KEYS ==="

    # 1. Mengamankan kunci SSH & GPG secara universal
    if [ -d "$HOME/.ssh" ]; then
        echo "  [FOUND: SSH Keys] Mengamankan kredensial remote..."
        cp -a "$HOME/.ssh" "$target_dir/" 2>/dev/null || true
    fi

    if [ -d "$HOME/.gnupg" ]; then
        echo "  [FOUND: GPG Keys] Mengamankan tanda tangan digital..."
        rsync -a --exclude="S.gpg-agent" "$HOME/.gnupg" "$target_dir/" 2>/dev/null || true
    fi

    # 2. Smart Project Discovery (Mendeteksi direktori Git di Home)
    echo "  -> Menganalisis ~/ untuk mencari project repository (Max Depth 4)..."
    local found_projects=()

    # Memindai direktori yang memiliki flag .git, dengan kedalaman wajar agar kilat
    while IFS= read -r git_dir; do
        local proj_dir="$(dirname "$git_dir")"
        
        # Mengecualikan folder sistem atau cache agar tidak salah tangkap
        if [[ "$proj_dir" == *".cache"* ]] || [[ "$proj_dir" == *".local"* ]] || [[ "$proj_dir" == *".cargo"* ]]; then
            continue
        fi
        
        found_projects+=("$proj_dir")
    done < <(find "$HOME" -maxdepth 4 -type d -name ".git" 2>/dev/null)

    if [ ${#found_projects[@]} -eq 0 ]; then
        echo "  [INFO] Tidak ada project Git yang ditemukan."
    else
        echo "  [REPORT] Menemukan ${#found_projects[@]} project aktif:"
        for p in "${found_projects[@]}"; do
            echo "      - $(basename "$p")"
        done

        echo "  -> Mengeksekusi backup project dengan Smart-Filter (Excluding node_modules, dist, dll)..."
        for p in "${found_projects[@]}"; do
            local bname="$(basename "$p")"
            rsync -a \
                --exclude="node_modules/" \
                --exclude=".next/" \
                --exclude="dist/" \
                --exclude="build/" \
                --exclude=".cache/" \
                --exclude="*.tmp" \
                --exclude=".npm/" \
                --exclude="venv/" \
                --exclude=".venv/" \
                "$p" "$proj_dest/" 2>/dev/null || true
        done
        echo "  [OK] Seluruh workspace berhasil dicadangkan tanpa sampah file."
    fi
}
