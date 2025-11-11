# Install Metapac via Cargo
setup-metapac:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Installing Metapac..."
    
    # Check if cargo is installed
    if ! command -v cargo &> /dev/null; then
        echo "❌ Cargo not found. Please run: ujust setup-rust"
        exit 1
    fi
    
    # Check if metapac is already installed
    if command -v metapac &> /dev/null; then
        echo "✓ Metapac already installed ($(metapac --version))"
        exit 0
    fi
    
    # Install metapac
    cargo install metapac
    
    echo "✓ Metapac installed successfully"
    metapac --version