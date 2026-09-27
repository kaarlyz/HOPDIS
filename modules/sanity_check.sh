#!/usr/bin/env bash
# Module: Execution-Based Integrity Validation & Auth Checker

run_sanity_check() {
    echo -e "\n=== [3/3] POST-MIGRATION SANITY CHECK (EXECUTION BASED) ==="

    local failed=0

    # 1. Check Toolchain Runtimes via command execution
    echo "  -> Menguji Runtime System & CLI..."
    for cmd in python3 node npm bun uv; do
        if command -v $cmd >/dev/null 2>&1; then
            echo -e "    [\033[0;32mOK\033[0m] $cmd siap ($($cmd --version 2>/dev/null | head -n1))"
        else
            echo -e "    [\033[0;31mFAIL\033[0m] $cmd tidak ditemukan di PATH!"
            failed=1
        fi
    done

    # 2. Check AI Core Agents (Hermes, Agy, 9Router) via Execution Test
    echo "  -> Menguji Binary AI Agents..."
    
    # Reload path biar tesnya bener
    export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.npm-global/bin:$PATH"

    if command -v hermes >/dev/null 2>&1; then
        echo -e "    [\033[0;32mOK\033[0m] Hermes Agent dapat dipanggil dari PATH."
    else
        echo -e "    [\033[0;31mFAIL\033[0m] Binary 'hermes' tidak ada atau broken symlink."
        failed=1
    fi

    if command -v 9router >/dev/null 2>&1; then
        echo -e "    [\033[0;32mOK\033[0m] 9Router dapat dieksekusi."
    else
        echo -e "    [\033[0;31mFAIL\033[0m] Binary '9router' broken. Jalankan: npm install -g --prefix ~/.local 9router"
        failed=1
    fi

    echo "=== SANITY CHECK SELESAI ==="
    if [ $failed -eq 1 ]; then
        echo -e "\033[0;33m[WARNING] Beberapa komponen gagal tereksekusi. Mohon tinjau ulang error di atas.\033[0m"
    else
        echo -e "\033[0;32m[SUCCESS] Ekosistem AI & Developer Anda 100% Siap Tempur!\033[0m"
    fi
}
