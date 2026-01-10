# 20-sync-dots.just

sync-dots:
    #!/usr/bin/bash
    # Check if we are inside a Hyprland session
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "CRITICAL: You are currently running Hyprland."
        echo "Please don't run this script directly in Hyprland to avoid issues during installation."
        echo "Log into a GNOME session or a TTY to execute this sync."
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit 1
    fi

    echo "WARNING: This will overwrite existing dotfiles in your home directory."
    read -p "Are you sure you want to continue? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Sync cancelled."
        exit 0
    fi

    echo "Copying base dotfiles from system template to home..."
    # The '.' copies the contents of the folder (including hidden files) into ~
    cp -rf /usr/share/dotfiles/. ~

    echo "----------------------------------------------------------------------"
    echo "Done! Your base environment is now ready, you can log into Hyprland now."
