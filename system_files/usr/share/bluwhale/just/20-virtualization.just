# /usr/share/ublue-os/just/20-virtualizaton.just
# Virtualization Setup for Kinoite
# Run with: just --justfile virtualization.just setup

# Set up virtualization with virt-manager (Flatpak) and USB passthrough
setup:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "=========================================="
    echo "Setting up Virtualization on Kinoite"
    echo "=========================================="
    echo
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then 
        echo "ERROR: Please run this as a regular user, not as root."
        echo "The script will ask for sudo password when needed."
        exit 1
    fi
    
    # Install virt-manager and QEMU extension from Flathub
    echo "Installing virt-manager and QEMU extension..."
    if flatpak list | grep -q "org.virt_manager.virt-manager"; then
        echo "✓ virt-manager already installed"
    else
        echo "Installing virt-manager..."
        flatpak install -y flathub org.virt_manager.virt-manager
        echo "✓ Installed virt-manager"
    fi
    
    if flatpak list | grep -q "org.virt_manager.virt_manager.Extension.Qemu"; then
        echo "✓ QEMU extension already installed"
    else
        echo "Installing QEMU extension..."
        flatpak install -y flathub org.virt_manager.virt_manager.Extension.Qemu
        echo "✓ Installed QEMU extension"
    fi
    
    echo
    
    # Create udev rule for USB passthrough
    echo "Creating udev rule for USB passthrough..."
    UDEV_RULE_FILE="/etc/udev/rules.d/50-usb-passthrough.rules"
    UDEV_RULE_CONTENT='SUBSYSTEM=="usb", MODE="0660", GROUP="kvm"'
    
    if [ -f "$UDEV_RULE_FILE" ]; then
        echo "✓ Udev rule already exists"
    else
        echo "$UDEV_RULE_CONTENT" | sudo tee "$UDEV_RULE_FILE" > /dev/null
        echo "✓ Created udev rule: $UDEV_RULE_FILE"
    fi
    
    echo
    
    # Add user to kvm group
    echo "Adding user '$USER' to 'kvm' group..."
    if groups "$USER" | grep -q "\bkvm\b"; then
        echo "✓ Already in kvm group"
    else
        sudo usermod -aG kvm "$USER"
        echo "✓ Added to kvm group"
    fi
    
    echo
    
    # Add user to libvirt group (if it exists)
    echo "Adding user '$USER' to 'libvirt' group..."
    if getent group libvirt > /dev/null 2>&1; then
        if groups "$USER" | grep -q "\blibvirt\b"; then
            echo "✓ Already in libvirt group"
        else
            sudo usermod -aG libvirt "$USER"
            echo "✓ Added to libvirt group"
        fi
    else
        echo "⚠ libvirt group doesn't exist (this is normal for Flatpak-only setup)"
    fi
    
    echo
    
    # Reload udev rules
    echo "Reloading udev rules..."
    sudo udevadm control --reload-rules
    echo "✓ Reloaded udev rules"
    
    echo
    
    echo "Triggering udev..."
    sudo udevadm trigger
    echo "✓ Triggered udev"
    
    echo
    echo "=========================================="
    echo "Setup complete!"
    echo "=========================================="
    echo
    echo "IMPORTANT: You must LOG OUT and LOG BACK IN for group changes to take effect."
    echo
    echo "After logging back in:"
    echo "1. Open virt-manager"
    echo "2. Go to File → Add Connection"
    echo "3. Select 'QEMU/KVM user session' from the Hypervisor dropdown"
    echo "4. Click OK"
    echo
    echo "You can now create VMs with USB passthrough support!"
    echo

# Remove virtualization setup
remove:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Removing virtualization setup..."
    echo
    
    # Remove flatpaks
    echo "Removing Flatpak applications..."
    flatpak uninstall -y org.virt_manager.virt_manager.Extension.Qemu || true
    flatpak uninstall -y org.virt_manager.virt-manager || true
    echo "✓ Removed Flatpak applications"
    
    echo
    
    # Remove udev rule
    echo "Removing udev rule..."
    sudo rm -f /etc/udev/rules.d/50-usb-passthrough.rules
    echo "✓ Removed udev rule"
    
    echo
    
    # Note about groups (don't automatically remove user from groups)
    echo "Note: User groups (kvm, libvirt) were not modified."
    echo "If you want to remove yourself from these groups, run:"
    echo "  sudo gpasswd -d $USER kvm"
    echo "  sudo gpasswd -d $USER libvirt"
    echo
    
    # Reload udev
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    
    echo "Removal complete!"
    echo

# Check if virtualization is set up correctly
check:
    #!/usr/bin/bash
    set -euo pipefail
    
    echo "Checking virtualization setup..."
    echo
    
    # Check if virt-manager is installed
    if flatpak list | grep -q "org.virt_manager.virt-manager"; then
        echo "✓ virt-manager is installed"
    else
        echo "✗ virt-manager is NOT installed"
    fi
    
    # Check if QEMU extension is installed
    if flatpak list | grep -q "org.virt_manager.virt_manager.Extension.Qemu"; then
        echo "✓ QEMU extension is installed"
    else
        echo "✗ QEMU extension is NOT installed"
    fi
    
    # Check if udev rule exists
    if [ -f "/etc/udev/rules.d/50-usb-passthrough.rules" ]; then
        echo "✓ Udev rule exists"
    else
        echo "✗ Udev rule does NOT exist"
    fi
    
    # Check if user is in kvm group
    if groups "$USER" | grep -q "\bkvm\b"; then
        echo "✓ User is in kvm group"
    else
        echo "✗ User is NOT in kvm group"
    fi
    
    # Check if user is in libvirt group
    if getent group libvirt > /dev/null 2>&1; then
        if groups "$USER" | grep -q "\blibvirt\b"; then
            echo "✓ User is in libvirt group"
        else
            echo "✗ User is NOT in libvirt group"
        fi
    else
        echo "⚠ libvirt group doesn't exist (normal for Flatpak-only setup)"
    fi
    
    echo
    echo "Setup check complete!"
    echo
