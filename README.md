# 🚀 HOPDIS — Universal Linux State & Zero-ReLogin Migrator

**HOPDIS** adalah tool migrasi otomatis untuk pengguna Linux dan *distro-hopper*:
- 🚫 **Zero-ReLogin**: Sesi Telegram Desktop (`tdata`), Google Chrome, Brave, Firefox, Discord, dan SSH tetap login tanpa perlu scan QR / OTP lagi.
- 🤖 **AI Stack Ready**: Mendukung penuh backup & restore **Hermes Agent, 9Router Gateway, Antigravity, OpenCode, Claude Code, Cursor, Ollama**.
- 🔄 **Cross-Distro Detection**: Otomatis mendeteksi OS target (Debian/Ubuntu/Pop!_OS, Arch/Manjaro, Fedora, openSUSE) dan memasang package penunjang.
- ⚡ **Auto-Discovery Engine**: Memindai seluruh folder `~/.config` dan `~/.local/share` untuk mengamankan konfigurasi aplikasi tersembunyi.
- ⚙️ **Auto Systemd & Binary**: Mengaktifkan ulang user service (`gemini-bridge`, `hermes-gateway`, dsb) dan symlink `~/.local/bin`.

---

## 📦 Apa Saja yang Dimigrasikan?

1. **Browser Sessions**: Chrome, Brave, Chromium, Firefox, LibreWolf (Cookies, Logins, Extensions, LocalStorage).
2. **Chat & Communication**: Telegram Desktop (`tdata`), Discord, WhatsApp Linux, Slack, Signal, Thunderbird.
3. **AI Agents & Developer Stack**:
   - `~/.hermes/` (Skills, memory, sessions, configs)
   - `~/.9router/` (Auth secret, token SQLite database, proxy runtime)
   - `~/.config/antigravity` & `~/.local/share/antigravity`
   - `~/.config/opencode` & `~/.local/share/opencode`
   - Claude Code, Cursor, Ollama
4. **Auth & Security**: SSH keys (`~/.ssh`), GPG, Git config, GitHub CLI, Linux Keyrings (GNOME/KDE Vault), Ngrok, Cloudflared.
5. **Software Manifest**: Catatan lengkap package manager (APT / Pacman / DNF / Flatpak / Snap / NPM global / Pip).
6. **System & Shell**: Systemd user services, `~/.local/bin`, `.bashrc`, `.zshrc`, `.profile`.

---

## 🚀 Cara Penggunaan

### 1. Di Distro Lama (Buat Backup)
Jalankan satu perintah ini:
```bash
./backup.sh
# atau
./bin/hop backup
```
File arsip terkompresi `distrohop_backup_YYYYMMDD_HHMMSS.tar.zst` (atau `.tar.gz`) akan tersimpan di folder ini.

---

### 2. Di Distro Baru (Restore Semuanya)
Pindahkan file backup ke distro baru, lalu jalankan:
```bash
./restore.sh distrohop_backup_*.tar.zst
# atau
./bin/hop restore distrohop_backup_*.tar.zst
```

Semua software esensial akan diinstall, seluruh session login dan AI agents langsung hidup kembali tanpa perlu login ulang satu pun!

---

## 🛡️ Keamanan
File archive backup diabaikan oleh `.gitignore` sehingga aman dari risiko tidak sengaja ter-push ke GitHub publik.
