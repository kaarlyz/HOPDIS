# 🚀 HOPDIS — Universal Linux & Windows-to-Linux Zero-ReLogin Migrator

**HOPDIS** adalah tool migrasi otomatis untuk pengguna Linux, *distro-hopper*, dan pengguna Windows yang ingin migrasi ke Linux tanpa rasa sakit:
- 🚫 **Zero-ReLogin**: Sesi Telegram Desktop (`tdata`), Google Chrome, Brave, Firefox, Discord, dan SSH tetap aktif tanpa perlu scan QR / OTP lagi.
- 🪟 **Windows-to-Linux Migration**: Dilengkapi modul PowerShell untuk migrasi profil browser, chat, dan mapping otomatis software Windows ke alternatif open-source Linux.
- 🤖 **AI Stack Ready**: Mendukung penuh backup & restore **Hermes Agent, 9Router Gateway, Antigravity, OpenCode, Claude Code, Cursor, Ollama**.
- 🔄 **Cross-Distro Detection**: Otomatis mendeteksi OS target (Debian/Ubuntu/Pop!_OS, Arch/Manjaro, Fedora, openSUSE) dan memasang package penunjang.
- 🎛️ **Interactive TUI Selection**: Dialog interaktif untuk memilih komponen mana saja yang ingin dicadangkan.
- 📊 **Post-Restore Sanity Check**: Laporan kesehatan otomatis setelah restore untuk memverifikasi Python, Node.js, UV, Git, SSH, dan AI Services.
- ☁️ **Cloud Storage Integration**: Dukungan upload langsung ke Google Drive, OneDrive, atau Mega via Rclone.

---

## ⚡ Quick Start (One-Liner Web Installer)

Di terminal Linux baru, cukup jalankan 1 baris ini untuk memasang HOPDIS langsung ke `~/.local/bin/hop`:
```bash
curl -fsSL https://raw.githubusercontent.com/kaarlyz/HOPDIS/main/install.sh | bash
```

---

## 🐧 Cara Penggunaan Antar-Distro Linux

### 1. Backup di Distro Lama
```bash
hop backup
# Atau backup semua komponen tanpa dialog TUI:
hop backup --all
```

### 2. Restore di Distro Baru
```bash
hop restore distrohop_backup_*.tar.zst
```

### 3. Cek Status Kesehatan Sistem
```bash
hop check
```

---

## 🪟 Cara Migrasi dari Windows ke Linux

1. Di komputer Windows, jalankan file PowerShell di folder `windows/`:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\windows\hop-export.ps1
   ```
2. File `hopdis_windows_migration_*.zip` akan dibuat secara otomatis.
3. Salin file `.zip` tersebut ke sistem Linux baru Anda, lalu jalankan:
   ```bash
   hop restore hopdis_windows_migration_*.zip
   ```
4. HOPDIS akan otomatis:
   - Memetakan dan menginstal alternatif aplikasi Windows (contoh: Microsoft Office ➔ LibreOffice, Notepad++ ➔ Kate, dsb).
   - Memulihkan sesi Chrome, Brave, Firefox, dan Telegram.
   - Menata hak akses kunci SSH ke standar keamanan Linux (`chmod 600`).
   - Menjalankan sanity report menyeluruh.
