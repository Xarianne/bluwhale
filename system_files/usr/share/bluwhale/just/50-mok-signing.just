# /usr/share/bluwhale/just/50-mok-signing.just
# MOK (Machine Owner Key) Setup for Kernel Module Signing
# Run with: just --justfile 50-mok-signing.just setup-mok

# Generate MOK keys and enroll them for Secure Boot
setup-mok:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "=========================================="
    echo "Setting up MOK Keys for Secure Boot"
    echo "=========================================="
    echo
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then 
        echo "ERROR: Please run this as a regular user, not as root."
        echo "The script will ask for sudo password when needed."
        exit 1
    fi
    
    # Create directory for keys
    KEYS_DIR="$HOME/.mok-keys"
    mkdir -p "$KEYS_DIR"
    cd "$KEYS_DIR"
    
    echo "Keys will be stored in: $KEYS_DIR"
    echo
    
    # Check if keys already exist
    if [ -f "$KEYS_DIR/MOK.der" ] && [ -f "$KEYS_DIR/MOK.priv" ]; then
        echo "⚠️  MOK keys already exist in $KEYS_DIR"
        echo "If you want to regenerate keys, manually delete them first:"
        echo "  rm -rf $KEYS_DIR"
        echo
        read -p "Use existing keys? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborting. Please remove existing keys and run again."
            exit 1
        fi
    else
        echo "Creating OpenSSL configuration file..."
        cat > mokconfig.cnf << 'EOF'
HOME = .
RANDFILE = $ENV::HOME/.rnd

[ req ]
distinguished_name = req_distinguished_name
x509_extensions = v3
string_mask = utf8only
prompt = no

[ req_distinguished_name ]
countryName = US
stateOrProvinceName = State
localityName = City
0.organizationName = Personal
commonName = Secure Boot Signing Key
emailAddress = user@localhost

[ v3 ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage = codeSigning,1.3.6.1.4.1.311.10.3.6
nsComment = "OpenSSL Generated Certificate"
EOF
        
        echo "✓ Created OpenSSL configuration"
        echo
        
        echo "Generating RSA key pair (this may take a moment)..."
        openssl req -config ./mokconfig.cnf \
            -new -x509 -newkey rsa:2048 \
            -nodes -days 36500 -outform DER \
            -keyout "MOK.priv" \
            -out "MOK.der"
        
        echo "✓ Generated MOK.der and MOK.priv"
        echo
        
        echo "Converting key to PEM format..."
        openssl x509 -in MOK.der -inform DER -outform PEM -out MOK.pem
        
        echo "✓ Generated MOK.pem"
        echo
    fi
    
    # Import the key to MOK
    echo "Importing key to MOK database..."
    echo "You will be prompted to enter a password. Remember this password!"
    echo "You will need to enter it during the next boot to complete enrollment."
    echo
    
    sudo mokutil --import "$KEYS_DIR/MOK.der"
    
    echo
    echo "=========================================="
    echo "MOK Key Generation Complete!"
    echo "=========================================="
    echo
    echo "IMPORTANT: REBOOT REQUIRED"
    echo
    echo "Your keys are stored in: $KEYS_DIR"
    echo "  - MOK.der  (public key in DER format)"
    echo "  - MOK.pem  (public key in PEM format)"
    echo "  - MOK.priv (private key - KEEP SECURE!)"
    echo
    echo "Next steps:"
    echo "1. REBOOT your system"
    echo "2. During boot, you'll see a blue MOK Management screen"
    echo "3. Select 'Enroll MOK'"
    echo "4. Select 'Continue'"
    echo "5. Select 'Yes' to enroll the key"
    echo "6. Enter the password you just set"
    echo "7. Select 'Reboot'"
    echo
    echo "After rebooting, verify enrollment with:"
    echo "  just --justfile 50-mok-signing.just check-mok"
    echo
    echo "To sign a kernel module, use:"
    echo "  just --justfile 50-mok-signing.just sign-module <path/to/module.ko>"
    echo

# Sign a kernel module with MOK key
sign-module MODULE_PATH:
    #!/usr/bin/bash
    set -euo pipefail
    
    KEYS_DIR="$HOME/.mok-keys"
    MODULE_PATH="{{ MODULE_PATH }}"
    
    echo "Signing kernel module: $MODULE_PATH"
    echo
    
    # Check if keys exist
    if [ ! -f "$KEYS_DIR/MOK.priv" ] || [ ! -f "$KEYS_DIR/MOK.der" ]; then
        echo "ERROR: MOK keys not found in $KEYS_DIR"
        echo "Please run: just --justfile 50-mok-signing.just setup-mok"
        exit 1
    fi
    
    # Check if module exists
    if [ ! -f "$MODULE_PATH" ]; then
        echo "ERROR: Module not found: $MODULE_PATH"
        exit 1
    fi
    
    # Find the sign-file script
    KERNEL_VERSION=$(uname -r)
    SIGN_FILE="/usr/src/kernels/$KERNEL_VERSION/scripts/sign-file"
    
    if [ ! -f "$SIGN_FILE" ]; then
        # Try alternative location
        SIGN_FILE="/lib/modules/$KERNEL_VERSION/build/scripts/sign-file"
    fi
    
    if [ ! -f "$SIGN_FILE" ]; then
        echo "ERROR: sign-file script not found"
        echo "Please install kernel-devel package:"
        echo "  sudo dnf install kernel-devel"
        exit 1
    fi
    
    # Sign the module
    echo "Using sign-file: $SIGN_FILE"
    echo "Signing with SHA256..."
    
    sudo "$SIGN_FILE" sha256 \
        "$KEYS_DIR/MOK.priv" \
        "$KEYS_DIR/MOK.der" \
        "$MODULE_PATH"
    
    echo
    echo "✓ Module signed successfully: $MODULE_PATH"
    echo
    echo "You can now load the module with: sudo modprobe <module_name>"
    echo

# Check if MOK key is enrolled
check-mok:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Checking MOK enrollment status..."
    echo
    
    KEYS_DIR="$HOME/.mok-keys"
    
    # Check if keys exist locally
    if [ -f "$KEYS_DIR/MOK.der" ]; then
        echo "✓ MOK keys found in $KEYS_DIR"
    else
        echo "✗ MOK keys NOT found in $KEYS_DIR"
        echo "  Run: just --justfile 50-mok-signing.just setup-mok"
    fi
    
    echo
    
    # Check if key is enrolled in MOK
    echo "Checking enrolled MOK keys..."
    mokutil --list-enrolled
    
    echo
    
    # Check Secure Boot status
    echo "Secure Boot status:"
    mokutil --sb-state
    
    echo
    
    # Check if key is in trusted keyring (requires reboot after enrollment)
    echo "Checking kernel trusted keyring..."
    if sudo keyctl show %:.builtin_trusted_keys 2>/dev/null | grep -q "Secure Boot Signing Key"; then
        echo "✓ MOK key found in kernel trusted keyring"
    else
        echo "⚠️  MOK key not yet in kernel trusted keyring"
        echo "    If you just enrolled, reboot to complete the process"
    fi
    
    echo
    echo "Check complete!"
    echo

# Remove MOK keys (does not unenroll from firmware)
remove-mok:
    #!/usr/bin/bash
    set -euo pipefail
    
    KEYS_DIR="$HOME/.mok-keys"
    
    echo "This will remove MOK keys from: $KEYS_DIR"
    echo "NOTE: This does NOT unenroll keys from firmware MOK database."
    echo
    read -p "Are you sure you want to delete the keys? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$KEYS_DIR"
        echo "✓ Removed MOK keys from $KEYS_DIR"
        echo
        echo "To unenroll from firmware, run:"
        echo "  sudo mokutil --delete <path/to/MOK.der>"
        echo "  (then reboot and follow the MOK Management prompts)"
    else
        echo "Cancelled."
    fi
    echo

# Helper: Sign xone module specifically
sign-xone:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Searching for xone kernel module..."
    echo
    
    KERNEL_VERSION=$(uname -r)
    XONE_PATHS=(
        "/lib/modules/$KERNEL_VERSION/extra/xone.ko"
        "/lib/modules/$KERNEL_VERSION/extra/xone.ko.xz"
        "/usr/lib/modules/$KERNEL_VERSION/extra/xone.ko"
        "/usr/lib/modules/$KERNEL_VERSION/extra/xone.ko.xz"
    )
    
    FOUND=false
    for path in "${XONE_PATHS[@]}"; do
        if [ -f "$path" ]; then
            echo "Found xone module at: $path"
            
            # If compressed, decompress first
            if [[ "$path" == *.xz ]]; then
                echo "Decompressing module..."
                DECOMPRESSED="${path%.xz}"
                sudo xz -dk "$path"
                path="$DECOMPRESSED"
            fi
            
            just --justfile /usr/share/bluwhale/just/50-mok-signing.just sign-module "$path"
            FOUND=true
            break
        fi
    done
    
    if [ "$FOUND" = false ]; then
        echo "ERROR: xone module not found"
        echo "Searched in:"
        for path in "${XONE_PATHS[@]}"; do
            echo "  - $path"
        done
        echo
        echo "Is xone installed? Check with: modinfo xone"
        exit 1
    fi
    echo
