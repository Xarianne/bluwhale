# 40-shell-fish.just

set-fish-shell:
    #!/usr/bin/bash
    set -euo pipefail

    # Resolve current user and fish path
    USER_NAME="${SUDO_USER:-$USER}"
    FISH_PATH="$(command -v fish || true)"

    if [[ -z "$FISH_PATH" ]]; then
        echo "fish is not installed; install it first (it is in packages-system.yml)."
        exit 1
    fi

    # Ensure fish is in /etc/shells
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "Adding $FISH_PATH to /etc/shells (needs sudo)..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    echo "Setting default shell for $USER_NAME to $FISH_PATH (needs sudo)..."
    sudo chsh -s "$FISH_PATH" "$USER_NAME"

    echo "✓ $USER_NAME will now use fish as the default shell."
