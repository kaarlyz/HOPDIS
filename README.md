# 🚀 HOPDIS — Universal Linux & Windows-to-Linux Zero-ReLogin Migrator

**HOPDIS** adalah tool migrasi otomatis untuk pengguna Linux, *distro-hopper*, dan pengguna Windows yang ingin migrasi ke Linux tanpa rasa sakit:
- 🚫 **Zero-ReLogin**: Sesi Telegram Desktop (`tdata`), Google Chrome, Brave, Firefox, Discord, dan SSH tetap aktif tanpa perlu scan QR / OTP ulang.
- 🪟 **Windows-to-Linux Migration**: Dilengkapi modul PowerShell untuk migrasi profil browser, chat, dan mapping otomatis software Windows ke alternatif open-source Linux.
- 🤖 **AI Stack Ready**: Mendukung penuh backup & restore **Hermes Agent, 9Router Gateway, Antigravity, OpenCode, Claude Code, Cursor, Ollama**.
- 🔄 **Cross-Distro Detection**: Otomatis mendeteksi OS target (Debian/Ubuntu/Pop!_OS, Arch/Manjaro, Fedora, openSUSE) dan memasang package penunjang.
- 🎛️ **Interactive TUI Selection**: Dialog interaktif untuk memilih komponen mana saja yang ingin dicadangkan.

---

## 🪟 Cara Migrasi dari Windows ke Linux

1. Di komputer Windows, jalankan file PowerShell di folder `windows/`:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\windows\hop-export.ps1
   ```
2. File `hopdis_windows_migration_*.zip` akan dibuat secara otomatis.
3. Salin file `.zip` tersebut ke sistem Linux baru Anda, lalu jalankan:
   ```bash
   ./restore.sh hopdis_windows_migration_*.zip
   ```
4. HOPDIS akan otomatis:
   - Memetakan dan menginstal alternatif aplikasi Windows (contoh: Microsoft Office ➔ LibreOffice, Notepad++ ➔ Kate, dsb).
   - Memulihkan sesi Chrome, Brave, Firefox, dan Telegram.
   - Menata hak akses kunci SSH ke standar keamanan Linux (`chmod 600`).

---

## 🐧 Cara Penggunaan Antar-Distro Linux

### 1. Backup di Distro Lama
```bash
./backup.sh
# Atau tanpa dialog TUI:
./backup.sh --all
```

### 2. Restore di Distro Baru
```bash
./restore.sh distrohop_backup_*.tar.zst
```
