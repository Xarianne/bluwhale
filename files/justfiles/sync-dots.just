# 20-sync-dots.just

sync-dots:
    #!/usr/bin/bash
    set -euo pipefail

    SOURCE_DIR="/usr/share/dotfiles"
    
    echo "WARNING: This will overwrite existing dotfiles in your home directory ($HOME)."
    read -p "Are you sure you want to continue? (y/N): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Sync cancelled."
        exit 0
    fi

    if [ -d "$SOURCE_DIR" ]; then
        echo "Syncing dotfiles from $SOURCE_DIR..."
        rsync -avP "$SOURCE_DIR/" "$HOME/"
    else
        echo "Error: Source directory $SOURCE_DIR not found in image."
        exit 1
    fi

    echo "----------------------------------------------------------------------"
    echo "Done!"