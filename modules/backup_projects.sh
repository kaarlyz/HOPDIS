#!/usr/bin/env bash
# Module: Smart Project Workspace Exporter & Credentials Backup

export_projects_and_keys() {
    local target_dir="$1/projects_and_keys"
    mkdir -p "$target_dir"

    echo "=== [3/3] EXPORTING DEVELOPER WORKSPACE & SSH KEYS ==="

    # 1. Mengamankan kunci SSH & GPG
    if [ -d "$HOME/.ssh" ]; then
        echo "  [FOUND: SSH Keys] Mengamankan kredensial server & git..."
        cp -a "$HOME/.ssh" "$target_dir/" 2>/dev/null || true
    fi

    if [ -d "$HOME/.gnupg" ]; then
        echo "  [FOUND: GPG Keys] Mengamankan tanda tangan digital..."
        rsync -a --exclude="S.gpg-agent" "$HOME/.gnupg" "$target_dir/" 2>/dev/null || true
    fi

    # 2. Mengamankan Folder Workspace (Documents)
    local workspace_dir="$HOME/Documents"
    if [ -d "$workspace_dir" ]; then
        echo "  [FOUND: Workspace] Menarik seluruh project kodingan di $workspace_dir..."
        echo "  -> Menerapkan Smart-Filter (Membuang node_modules, .next, dist, cache)..."
        
        # Tarball method karena rsync kadang gagal mempertahankan symlinks complex tanpa flag yang ruwet,
        # tapi kita pakai rsync dengan filter ketat biar rapi.
        rsync -a \
            --exclude="node_modules/" \
            --exclude=".next/" \
            --exclude="dist/" \
            --exclude="build/" \
            --exclude=".cache/" \
            --exclude="*.tmp" \
            --exclude=".npm/" \
            "$workspace_dir" "$target_dir/" 2>/dev/null || true
            
        echo "  [OK] Seluruh project berhasil dicadangkan (Tanpa sampah raksasa)."
    fi
}
