setup-dms:
    #!/usr/bin/bash
    set -euo pipefail

    TARGET_DIR="$HOME/.config/systemd/user"
    TARGET_FILE="$TARGET_DIR/hyprland-session.target"

    echo "Setting up Dank Material Shell (DMS) systemd components..."

    # 1. Create systemd user target
    echo "Creating systemd user target..."
    mkdir -p "$TARGET_DIR"
    cat <<EOF > "$TARGET_FILE"
    [Unit]
    Description=Hyprland Session Target
    Requires=graphical-session.target
    After=graphical-session.target
    EOF

    # 2. Bind DMS to the session target
    echo "Binding DMS to the session target..."
    systemctl --user add-wants hyprland-session.target dms

    echo "----------------------------------------------------------------------"
    echo "Systemd components for DMS are set up!"
