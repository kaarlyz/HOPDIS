# ==============================================================================
# HOPDIS — Windows to Linux State & Session Exporter (PowerShell)
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🚀 HOPDIS — WINDOWS TO LINUX MIGRATION EXPORTER" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ExportDir = "$env:TEMP\hopdis_win_export_$Timestamp"
$ZipOut = "$PSScriptRoot\hopdis_windows_migration_$Timestamp.zip"

New-Item -ItemType Directory -Force -Path "$ExportDir\browsers" | Out-Null
New-Item -ItemType Directory -Force -Path "$ExportDir\sessions" | Out-Null
New-Item -ItemType Directory -Force -Path "$ExportDir\manifests" | Out-Null

# 1. BROWSER SESSIONS (Chrome, Brave, Edge, Firefox)
Write-Host "[1/4] Mengekspor profil dan sesi browser..." -ForegroundColor Yellow

$ChromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
if (Test-Path $ChromePath) {
    Write-Host "  -> Ditemukan Google Chrome" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$ExportDir\browsers\google-chrome\Default" | Out-Null
    Copy-Item "$ChromePath\Cookies" "$ExportDir\browsers\google-chrome\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$ChromePath\Login Data" "$ExportDir\browsers\google-chrome\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$ChromePath\Web Data" "$ExportDir\browsers\google-chrome\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$ChromePath\Bookmarks" "$ExportDir\browsers\google-chrome\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$ChromePath\Preferences" "$ExportDir\browsers\google-chrome\Default\" -ErrorAction SilentlyContinue
}

$BravePath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default"
if (Test-Path $BravePath) {
    Write-Host "  -> Ditemukan Brave Browser" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$ExportDir\browsers\Brave-Browser\Default" | Out-Null
    Copy-Item "$BravePath\Cookies" "$ExportDir\browsers\Brave-Browser\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$BravePath\Login Data" "$ExportDir\browsers\Brave-Browser\Default\" -ErrorAction SilentlyContinue
    Copy-Item "$BravePath\Bookmarks" "$ExportDir\browsers\Brave-Browser\Default\" -ErrorAction SilentlyContinue
}

$FirefoxPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $FirefoxPath) {
    Write-Host "  -> Ditemukan Mozilla Firefox" -ForegroundColor Gray
    Copy-Item "$FirefoxPath" "$ExportDir\browsers\firefox" -Recurse -ErrorAction SilentlyContinue
}

# 2. CHAT & DEV SESSIONS (Telegram, SSH, Git, VSCode)
Write-Host "[2/4] Mengekspor sesi chat, kunci SSH, dan developer tools..." -ForegroundColor Yellow

$TDataPath = "$env:APPDATA\Telegram Desktop\tdata"
if (Test-Path $TDataPath) {
    Write-Host "  -> Ditemukan Telegram Desktop (tdata)" -ForegroundColor Gray
    Copy-Item "$TDataPath" "$ExportDir\sessions\TelegramDesktop\tdata" -Recurse -ErrorAction SilentlyContinue
}

$SSHPath = "$env:USERPROFILE\.ssh"
if (Test-Path $SSHPath) {
    Write-Host "  -> Ditemukan SSH Keys" -ForegroundColor Gray
    Copy-Item "$SSHPath" "$ExportDir\sessions\ssh" -Recurse -ErrorAction SilentlyContinue
}

$GitConfig = "$env:USERPROFILE\.gitconfig"
if (Test-Path $GitConfig) {
    Copy-Item "$GitConfig" "$ExportDir\sessions\gitconfig" -ErrorAction SilentlyContinue
}

# 3. SOFTWARE MANIFEST
Write-Host "[3/4] Menganalisis daftar software Windows yang terinstall..." -ForegroundColor Yellow
$InstalledApps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*, HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DisplayName | Sort-Object -Unique

$InstalledApps | Out-File "$ExportDir\manifests\windows_installed_apps.txt" -Encoding utf8

# 4. COMPRESS ARCHIVE
Write-Host "[4/4] Membuat file paket migrasi zip..." -ForegroundColor Yellow
Compress-Archive -Path "$ExportDir\*" -DestinationPath "$ZipOut" -Force
Remove-Item -Recurse -Force "$ExportDir"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "✅ EKSPOR BERHASIL!" -ForegroundColor Green
Write-Host "File paket migrasi: $ZipOut" -ForegroundColor White
Write-Host "Salin file ini ke Linux baru dan jalankan: ./restore.sh <nama_file.zip>" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
