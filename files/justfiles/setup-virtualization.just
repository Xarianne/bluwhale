# Master command: Setup everything for virtualization
setup-virt: setup-virt-permissions setup-virt-network
    @echo "Virtualization setup complete!"
    @echo ">>> IMPORTANT: You MUST reboot for group changes to take effect."

# Sync system groups (libvirt/kvm) to /etc and add current user
setup-virt-permissions:
    #!/usr/bin/env bash
    for group in libvirt kvm; do
        if ! grep -q "^$group:" /etc/group; then
            echo "Syncing $group group from /usr/lib/group to /etc/group..."
            grep -E "^$group:" /usr/lib/group | sudo tee -a /etc/group
        fi
    done
    sudo usermod -aG libvirt,kvm $USER
    echo "User added to libvirt and kvm groups."

# Initialize and start the default NAT network bridge (virbr0)
setup-virt-network:
    #!/usr/bin/env bash
    if ! sudo virsh net-info default >/dev/null 2>&1; then
        echo "Default network not found. Initializing..."
        sudo virsh net-define /usr/share/libvirt/networks/default.xml || true
    fi
    sudo virsh net-start default || true
    sudo virsh net-autostart default
    echo "Default network 'default' (virbr0) is now active."