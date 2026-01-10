#!/bin/bash
set -oue pipefail

# 1. Set Zsh as default for new users
sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd

# 2. Install Oh My Zsh system-wide
# We clone it into a system directory so it's baked into the image
git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh

# 3. Optional: Install common plugins
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting /usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# 4. Fix permissions so all users can read it
chmod -R 755 /usr/share/oh-my-zsh

# 5. Add the Bluwhale Welcome greeting
cat << 'EOF' >> /etc/zshrc
if [[ $- == *i* ]]; then
    fastfetch
    echo "Welcome to Bluwhale. Type 'show-menu' to see system commands."
    echo ""
fi
EOF
