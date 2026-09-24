#!/usr/bin/env bash
# Module: Package & App Manifest Exporter

export_packages() {
    local target_dir="$1/manifests"
    mkdir -p "$target_dir"

    echo "  -> Mencatat daftar software dan package terinstall..."

    # 1. Native Packages
    if command -v apt-mark >/dev/null 2>&1; then
        apt-mark showmanual > "$target_dir/apt_manual.txt" 2>/dev/null || true
        dpkg --get-selections | awk '{print $1}' > "$target_dir/apt_all.txt" 2>/dev/null || true
    fi

    if command -v pacman >/dev/null 2>&1; then
        pacman -Qqe > "$target_dir/pacman_explicit.txt" 2>/dev/null || true
        pacman -Qqm > "$target_dir/aur_explicit.txt" 2>/dev/null || true
    fi

    if command -v dnf >/dev/null 2>&1; then
        dnf repoquery --userinstalled --qf "%{name}" > "$target_dir/dnf_user.txt" 2>/dev/null || true
    fi

    # 2. Universal Packages (Flatpak & Snap)
    if command -v flatpak >/dev/null 2>&1; then
        flatpak list --app --columns=application > "$target_dir/flatpak_apps.txt" 2>/dev/null || true
    fi

    if command -v snap >/dev/null 2>&1; then
        snap list | awk 'NR>1 {print $1}' > "$target_dir/snap_apps.txt" 2>/dev/null || true
    fi

    # 3. Development runtimes & global tools
    if command -v npm >/dev/null 2>&1; then
        npm list -g --depth=0 --json > "$target_dir/npm_global.json" 2>/dev/null || true
    fi

    if command -v pip >/dev/null 2>&1; then
        pip list --format=freeze > "$target_dir/pip_freeze.txt" 2>/dev/null || true
    fi

    if command -v uv >/dev/null 2>&1; then
        uv tool list > "$target_dir/uv_tools.txt" 2>/dev/null || true
    fi

    echo "  [OK] Manifest tersimpan di $target_dir"
}
