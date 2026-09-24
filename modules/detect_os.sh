#!/usr/bin/env bash
# Module: OS & Package Manager Detection

detect_os_family() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="${ID:-unknown}"
        OS_LIKE="${ID_LIKE:-$OS_ID}"
        OS_NAME="${NAME:-Linux}"
    else
        OS_ID="unknown"
        OS_LIKE="unknown"
        OS_NAME="Linux"
    fi

    if command -v apt-get >/dev/null 2>&1; then
        PKG_MGR="apt"
        FAMILY="debian"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MGR="pacman"
        FAMILY="arch"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MGR="dnf"
        FAMILY="fedora"
    elif command -v zypper >/dev/null 2>&1; then
        PKG_MGR="zypper"
        FAMILY="suse"
    elif command -v apk >/dev/null 2>&1; then
        PKG_MGR="apk"
        FAMILY="alpine"
    else
        PKG_MGR="unknown"
        FAMILY="unknown"
    fi

    OS_FAMILY="$FAMILY"
}
