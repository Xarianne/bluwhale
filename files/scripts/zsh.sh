#!/bin/bash
set -oue pipefail

# 1. Set Zsh as the default for new users
sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd

# 2. Create the system-wide oh-my-zsh path
# This allows you to bake plugins into the image so they are 'read-only' and safe
mkdir -p /usr/share/oh-my-zsh/plugins

# 3. Fix Zsh Permissions
# Ensures zsh can be executed properly by all users
chmod +x /usr/bin/zsh

# Add the Bluwhale greeting to the global zshrc
cat << 'EOF' >> /etc/zshrc

# Bluwhale Welcome
if [[ $- == *i* ]]; then
    fastfetch
    echo "Welcome to Bluwhale. Type 'show-menu' to see system commands."
    echo ""
fi
EOF
