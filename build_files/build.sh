#!/bin/bash

set -ouex pipefail

# Enable COPRs
dnf5 -y copr enable danayer/Vulkan-Git
dnf5 -y copr enable danayer/libdrm-git
dnf5 -y copr enable danayer/linux-firmware-git
dnf5 -y copr enable danayer/mesa-git
dnf5 -y copr enable danayer/virglrenderer-git

# === Atomically swap the drivers ===
# Using one explicit swap command without variables.
# Note: This list is a best guess. If this step fails, you will
# need to check the build log for the exact conflicting packages.

dnf5 -y update

# Programs to remove
dnf5 remove -y \
    bazaar

# Programs to install
dnf5 install -y \
    plasma-discover \
    plasma-discover-flatpak

# Disable COPRs
dnf5 -y copr disable danayer/Vulkan-Git
dnf5 -y copr disable danayer/libdrm-git
dnf5 -y copr disable danayer/linux-firmware-git
dnf5 -y copr disable danayer/mesa-git
dnf5 -y copr disable danayer/virglrenderer-git

systemctl enable podman.socket
