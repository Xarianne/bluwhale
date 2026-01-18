# /usr/share/bluwhale/just/22-backup-gnome.just

backup-gnome:
    #!/usr/bin/bash
    set -euo pipefail

    # Set the backup directory to the user's Documents folder
    TARGET_DIR="$HOME/Documents/gnome-backup"
    mkdir -p "$TARGET_DIR"

    echo "Dumping GNOME configurations to $TARGET_DIR..."

    # 1. GNOME Text Editor Settings
    dconf dump /org/gnome/TextEditor/ > "$TARGET_DIR/gnome-text-editor.dconf"

    # 2. UI Interface (Dark mode, Fonts, Icons)
    dconf dump /org/gnome/desktop/interface/ > "$TARGET_DIR/gnome-interface.dconf"

    # 3. Comprehensive Keyboard Shortcuts
    dconf dump /org/gnome/desktop/wm/keybindings/ > "$TARGET_DIR/gnome-wm-keybindings.dconf"
    dconf dump /org/gnome/shell/keybindings/ > "$TARGET_DIR/gnome-shell-keybindings.dconf"
    dconf dump /org/gnome/mutter/keybindings/ > "$TARGET_DIR/gnome-mutter-keybindings.dconf"
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$TARGET_DIR/gnome-media-keys.dconf"

    # 4. GNOME Shell Extension Settings
    dconf dump /org/gnome/shell/extensions/ > "$TARGET_DIR/gnome-shell-extensions-backup.dconf"

    echo "Done! Settings have been backed up to $TARGET_DIR."
    echo "You can now move these files to /usr/share/gnome-backup/ in your repo."
