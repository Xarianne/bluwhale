# justfile
sync-dots:
    @echo "Syncing dotfiles from system template to home..."
    cp -rsf /usr/share/dotfiles/* ~/.config/
    @echo "Done! Restarting Hyprland/DMS to apply changes."
