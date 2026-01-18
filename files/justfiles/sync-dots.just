sync-dots:
    #!/usr/bin/bash
    set -euo pipefail

    SOURCE_DIR="/etc/skel"
    
    echo "WARNING: This will overwrite existing dotfiles in your home directory ($HOME)."
    read -p "Are you sure you want to continue? (y/N): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Sync cancelled."
        exit 0
    fi

    if [ -d "$SOURCE_DIR" ]; then
        echo "Syncing dotfiles from $SOURCE_DIR..."
        # -a (archive) preserves permissions, symlinks, etc.
        # --no-owner --no-group ensures files become owned by the current user
        rsync -avP --no-owner --no-group "$SOURCE_DIR/" "$HOME/"
    else
        echo "Error: Source directory $SOURCE_DIR not found."
        exit 1
    fi

    echo "----------------------------------------------------------------------"
    echo "Done!"