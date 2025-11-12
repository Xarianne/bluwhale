# Metapac via Cargo
setup-metapac:
    #!/usr/bin/bash
    echo "Installing metapac..."
    if command -v metapac &> /dev/null; then
        echo "✓ metapac already installed"
    else
        cargo install metapac
        echo "✓ Installed metapac to ~/.cargo/bin"
        echo "Make sure ~/.cargo/bin is in your PATH"
    fi
