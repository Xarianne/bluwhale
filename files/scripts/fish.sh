#!/usr/bin/env bash
set -euo pipefail

# Ensure fish is registered as a valid shell
if ! grep -q "/usr/bin/fish" /etc/shells; then
    echo "/usr/bin/fish" >> /etc/shells
fi

# Set default shell for root (and/or your user)
usermod -s /usr/bin/fish root
# If you have a non-root user in the image, add another usermod here
# usermod -s /usr/bin/fish youruser
