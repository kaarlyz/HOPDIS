#!/usr/bin/env bash
# ==============================================================================
# 🚀 HOPDIS — One-Liner Web Installer
# ==============================================================================
set -e

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_CYAN="\033[38;2;86;182;194m"
C_GREEN="\033[38;2;152;195;121m"

echo -e "${C_CYAN}${C_BOLD}▶ Menginstall HOPDIS ke sistem...${C_RESET}"

INSTALL_DIR="$HOME/.local/share/hopdis"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

if [ -d "$INSTALL_DIR/.git" ]; then
    echo "  -> Memperbarui repository HOPDIS lokal..."
    cd "$INSTALL_DIR" && git pull --quiet
else
    echo "  -> Mengunduh HOPDIS dari GitHub..."
    rm -rf "$INSTALL_DIR"
    git clone --quiet https://github.com/kaarlyz/HOPDIS.git "$INSTALL_DIR"
fi

# Create symlinks
chmod +x "$INSTALL_DIR/bin/hop" "$INSTALL_DIR"/*.sh "$INSTALL_DIR"/modules/*.sh
ln -sf "$INSTALL_DIR/bin/hop" "$BIN_DIR/hop"

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    export PATH="$BIN_DIR:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

echo -e "${C_GREEN}${C_BOLD}✔ HOPDIS berhasil dipasang!${C_RESET}"
echo -e "Sekarang Anda dapat menjalankan perintah ${C_CYAN}hop backup${C_RESET} atau ${C_CYAN}hop restore <file>${C_RESET} langsung dari terminal manapun.\n"
