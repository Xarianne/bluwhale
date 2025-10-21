#!/bin/bash
set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Enable the Tera COPRs (main and extra/mesa)
echo "🔧 Enabling Tera COPRs..."
dnf5 -y copr enable terrapkg/terra
dnf5 -y copr enable terrapkg/terra-extra

# Replace Fedora Mesa stack with Tera Mesa
echo "🌀 Replacing Mesa stack with Tera Mesa packages..."
dnf5 -y swap mesa mesa --repo=copr:copr.fedorainfracloud.org:terrapkg:terra-extra || true
dnf5 -y swap mesa-dri-drivers mesa-dri-drivers --repo=copr:copr.fedorainfracloud.org:terrapkg:terra-extra || true
dnf5 -y swap mesa-libEGL mesa-libEGL --repo=copr:copr.fedorainfracloud.org:terrapkg:terra-extra || true
dnf5 -y swap mesa-libGL mesa-libGL --repo=copr:copr.fedorainfracloud.org:terrapkg:terra-extra || true
dnf5 -y swap mesa-vulkan-drivers mesa-vulkan-drivers --repo=copr:copr.fedorainfracloud.org:terrapkg:terra-extra || true

# You can install any additional packages here (example)
dnf5 install -y tmux

# Disable the Tera COPRs so they don’t remain enabled on the final image
echo "🧹 Cleaning up COPRs..."
dnf5 -y copr disable terrapkg/terra
dnf5 -y copr disable terrapkg/terra-extra

# Clean up cached data
dnf5 clean all

#### Example for enabling a System Unit File
systemctl enable podman.socket

