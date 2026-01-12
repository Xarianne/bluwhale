# 20-sync-dots.just

sync-dots:
    #!/usr/bin/bash
    set -euo pipefail

    echo "WARNING: This will overwrite existing dotfiles in your home directory."
    read -p "Are you sure you want to continue? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Sync cancelled."
        exit 0
    fi

    echo "----------------------------------------------------------------------"
    echo "Done!"
