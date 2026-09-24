#!/usr/bin/env bash
# Module: Post-Restore Health Check & Sanity Report

run_sanity_check() {
    local C_RESET="\033[0m"
    local C_BOLD="\033[1m"
    local C_GREEN="\033[38;2;152;195;121m"
    local C_YELLOW="\033[38;2;229;192;123m"
    local C_RED="\033[38;2;224;108;117m"
    local C_CYAN="\033[38;2;86;182;194m"

    echo -e "\n${C_BOLD}${C_CYAN}══════════════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "${C_BOLD}📊 LAPORAN KESEHATAN SISTEM PASCA-RESTORISASI (SANITY CHECK)${C_RESET}"
    echo -e "${C_CYAN}══════════════════════════════════════════════════════════════════════${C_RESET}"

    # 1. Toolchains
    echo -e "${C_BOLD}▶ Runtime & Toolchains:${C_RESET}"
    command -v python3 >/dev/null 2>&1 && echo -e "  ${C_GREEN}✔ Python 3${C_RESET}       : $(python3 --version 2>/dev/null)" || echo -e "  ${C_RED}✖ Python 3       : Tidak ditemukan${C_RESET}"
    command -v node >/dev/null 2>&1 && echo -e "  ${C_GREEN}✔ Node.js${C_RESET}        : $(node --version 2>/dev/null)" || echo -e "  ${C_RED}✖ Node.js        : Tidak ditemukan${C_RESET}"
    command -v bun >/dev/null 2>&1 && echo -e "  ${C_GREEN}✔ Bun Runtime${C_RESET}    : $(bun --version 2>/dev/null)" || echo -e "  ${C_YELLOW}⚠ Bun Runtime    : Tidak terinstall${C_RESET}"
    command -v uv >/dev/null 2>&1 && echo -e "  ${C_GREEN}✔ Astral UV${C_RESET}      : $(uv --version 2>/dev/null)" || echo -e "  ${C_YELLOW}⚠ Astral UV      : Tidak terinstall${C_RESET}"
    command -v git >/dev/null 2>&1 && echo -e "  ${C_GREEN}✔ Git Version${C_RESET}    : $(git --version 2>/dev/null)" || echo -e "  ${C_RED}✖ Git            : Tidak ditemukan${C_RESET}"

    # 2. AI & Coding Agents
    echo -e "\n${C_BOLD}▶ Status Ekosistem AI:${C_RESET}"
    [ -d "$HOME/.hermes" ] && echo -e "  ${C_GREEN}✔ Hermes Agent${C_RESET}   : Konfigurasi & Memori Siap" || echo -e "  ${C_YELLOW}⚠ Hermes Agent   : Tidak ditemukan${C_RESET}"
    [ -d "$HOME/.9router" ] && echo -e "  ${C_GREEN}✔ 9Router Gateway${C_RESET}: Database Token & Auth Siap" || echo -e "  ${C_YELLOW}⚠ 9Router Gateway: Tidak ditemukan${C_RESET}"
    [ -d "$HOME/.config/opencode" -o -d "$HOME/.local/share/opencode" ] && echo -e "  ${C_GREEN}✔ OpenCode CLI${C_RESET}   : Konfigurasi & State Siap" || echo -e "  ${C_YELLOW}⚠ OpenCode CLI   : Tidak ditemukan${C_RESET}"
    [ -d "$HOME/.local/share/antigravity" ] && echo -e "  ${C_GREEN}✔ Antigravity${C_RESET}    : Binary state Siap" || echo -e "  ${C_YELLOW}⚠ Antigravity    : Tidak ditemukan${C_RESET}"

    # 3. Security & SSH
    echo -e "\n${C_BOLD}▶ Keamanan & Kredensial:${C_RESET}"
    if [ -d "$HOME/.ssh" ]; then
        local ssh_perm
        ssh_perm="$(stat -c "%a" "$HOME/.ssh" 2>/dev/null || stat -f "%Lp" "$HOME/.ssh" 2>/dev/null)"
        echo -e "  ${C_GREEN}✔ Direktori SSH${C_RESET}  : Terlindungi (Permission $ssh_perm)"
    else
        echo -e "  ${C_YELLOW}⚠ Direktori SSH  : Tidak ada kunci yang dimigrasikan${C_RESET}"
    fi
    [ -f "$HOME/.gitconfig" ] && echo -e "  ${C_GREEN}✔ Git Identity${C_RESET}   : $(git config --global user.name 2>/dev/null) <$(git config --global user.email 2>/dev/null)>" || echo -e "  ${C_YELLOW}⚠ Git Identity   : Belum diatur${C_RESET}"

    # 4. Sessions
    echo -e "\n${C_BOLD}▶ Sesi Aplikasi & Chat:${C_RESET}"
    [ -d "$HOME/.local/share/TelegramDesktop/tdata" ] && echo -e "  ${C_GREEN}✔ Telegram${C_RESET}       : Sesi tdata aktif (Zero-ReLogin)" || echo -e "  ${C_DIM}• Telegram       : Tidak ada sesi${C_RESET}"
    [ -d "$HOME/.mozilla/firefox" ] && echo -e "  ${C_GREEN}✔ Firefox${C_RESET}        : Profil & Cookie aktif" || echo -e "  ${C_DIM}• Firefox        : Tidak ada sesi${C_RESET}"
    [ -d "$HOME/.config/google-chrome" ] && echo -e "  ${C_GREEN}✔ Google Chrome${C_RESET}  : Profil & Cookie aktif" || echo -e "  ${C_DIM}• Google Chrome  : Tidak ada sesi${C_RESET}"
    [ -d "$HOME/.config/discord" ] && echo -e "  ${C_GREEN}✔ Discord${C_RESET}        : Sesi tersimpan" || echo -e "  ${C_DIM}• Discord        : Tidak ada sesi${C_RESET}"

    echo -e "${C_CYAN}══════════════════════════════════════════════════════════════════════${C_RESET}\n"
}
