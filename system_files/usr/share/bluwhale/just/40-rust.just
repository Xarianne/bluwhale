# Install Rust via Homebrew
setup-rust:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Installing Rust via Homebrew..."
    
    # Check if brew is installed
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please run: ujust setup-brew"
        exit 1
    fi
    
    # Check if rust is already installed
    if command -v rustc &> /dev/null; then
        echo "✓ Rust already installed ($(rustc --version))"
        exit 0
    fi
    
    # Install rust via brew
    brew install rust
    
    echo "✓ Rust installed successfully"
    rustc --version
    cargo --version