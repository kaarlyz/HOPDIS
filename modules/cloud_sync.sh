#!/usr/bin/env bash
# Module: Cloud Storage Exporter / Sync via Rclone

sync_to_cloud() {
    local archive_path="$1"
    local remote_target="$2"

    echo "=== [CLOUD SYNC] MENGUNGGAH FILE ARSIP KE CLOUD STORAGE ==="

    if ! command -v rclone >/dev/null 2>&1; then
        echo "  [INFO] Menginstall rclone CLI untuk sinkronisasi cloud..."
        sudo apt-get install -y rclone 2>/dev/null || sudo pacman -S --noconfirm rclone 2>/dev/null || sudo dnf install -y rclone 2>/dev/null || true
    fi

    if [ -z "$remote_target" ]; then
        echo "  [INFO] Menampilkan daftar remote storage yang terkonfigurasi di rclone:"
        rclone listremotes 2>/dev/null || echo "  (Belum ada remote rclone. Jalankan 'rclone config' untuk menambahkan Google Drive/OneDrive/Mega)"
        return 0
    fi

    echo "  -> Mengunggah $archive_path ke $remote_target..."
    rclone copy --progress "$archive_path" "$remote_target" 2>/dev/null || {
        echo "  [WARN] Gagal mengunggah ke $remote_target. Pastikan konfigurasi rclone sudah benar."
        return 1
    }

    echo "  [OK] Berhasil diunggah ke cloud: $remote_target"
}
