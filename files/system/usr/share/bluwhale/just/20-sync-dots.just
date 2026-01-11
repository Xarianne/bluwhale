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

    echo "Copying base dotfiles from system template to home..."
    # The '.' copies the contents of the folder (including hidden files) into ~
    cp -rf /usr/share/dotfiles/. ~

    echo "Restoring GNOME keyboard shortcuts and extension settings..."

    # Window manager keybindings
    if [[ -f /usr/share/gnome-backup/gnome-wm-keybindings.dconf ]]; then
        dconf load /org/gnome/desktop/wm/keybindings/ \
            < /usr/share/gnome-backup/gnome-wm-keybindings.dconf
    else
        echo "Warning: /usr/share/gnome-backup/gnome-wm-keybindings.dconf not found, skipping WM keybindings."
    fi

    # Media and custom shortcuts
    if [[ -f /usr/share/gnome-backup/gnome-media-keys.dconf ]]; then
        dconf load /org/gnome/settings-daemon/plugins/media-keys/ \
            < /usr/share/gnome-backup/gnome-media-keys.dconf
    else
        echo "Warning: /usr/share/gnome-backup/gnome-media-keys.dconf not found, skipping media/custom shortcuts."
    fi

    # GNOME Shell extension settings
    if [[ -f /usr/share/gnome-backup/gnome-shell-extensions-backup.dconf ]]; then
        dconf load /org/gnome/shell/extensions/ \
            < /usr/share/gnome-backup/gnome-shell-extensions-backup.dconf
    else
        echo "Warning: /usr/share/gnome-backup/gnome-shell-extensions-backup.dconf not found, skipping extension settings."
    fi

    echo "----------------------------------------------------------------------"
    echo "Done! Your base GNOME environment and shortcuts are now restored."
