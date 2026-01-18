# /usr/share/bluwhale/just/21-sync-gnome.just

sync-gnome:
    #!/usr/bin/bash
    set -euo pipefail

    # Only run if a GNOME session is detected to prevent errors in other DEs
    if [[ "${XDG_CURRENT_DESKTOP:-}" != *"GNOME"* ]]; then
        echo "Not a GNOME session. Skipping GNOME-specific configuration."
        exit 0
    fi

    BACKUP_DIR="/usr/share/gnome-backup"
    echo "Restoring GNOME-specific configurations (Text Editor, Interface, and Shortcuts)..."

    # 1. GNOME Text Editor Settings (Line numbers, theme, etc.)
    if [[ -f "$BACKUP_DIR/gnome-text-editor.dconf" ]]; then
        dconf load /org/gnome/TextEditor/ < "$BACKUP_DIR/gnome-text-editor.dconf"
    else
        echo "Warning: gnome-text-editor.dconf not found, skipping."
    fi

    # 2. UI Interface (System-wide Dark mode, Fonts, Icons)
    if [[ -f "$BACKUP_DIR/gnome-interface.dconf" ]]; then
        dconf load /org/gnome/desktop/interface/ < "$BACKUP_DIR/gnome-interface.dconf"
    else
        echo "Warning: gnome-interface.dconf not found, skipping."
    fi

    # 3. Comprehensive Keyboard Shortcuts (WM, Shell, Mutter, and Media keys)
    declare -A shortcuts=(
        ["/org/gnome/desktop/wm/keybindings/"]="gnome-wm-keybindings.dconf"
        ["/org/gnome/shell/keybindings/"]="gnome-shell-keybindings.dconf"
        ["/org/gnome/mutter/keybindings/"]="gnome-mutter-keybindings.dconf"
        ["/org/gnome/settings-daemon/plugins/media-keys/"]="gnome-media-keys.dconf"
    )

    for path in "${!shortcuts[@]}"; do
        file="$BACKUP_DIR/${shortcuts[$path]}"
        if [[ -f "$file" ]]; then
            dconf load "$path" < "$file"
        fi
    done

    # 4. GNOME Shell Extension Settings
    if [[ -f "$BACKUP_DIR/gnome-shell-extensions-backup.dconf" ]]; then
        dconf load /org/gnome/shell/extensions/ < "$BACKUP_DIR/gnome-shell-extensions-backup.dconf"
    fi

    echo "Done! GNOME environment restored."
