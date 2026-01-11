# Install Homebrew
setup-brew:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Installing Homebrew..."
    
    if command -v brew &> /dev/null; then
        echo "✓ Homebrew already installed"
        exit 0
    fi
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Set up shell environment
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Add to bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    
    echo "✓ Homebrew installed successfully"
    echo "Please restart your shell or run: source ~/.bashrc"
