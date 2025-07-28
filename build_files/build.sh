#!/bin/bash

set -ouex pipefail

# === Enable COPRs ===
echo "Enabling COPRs..."
dnf5 -y copr enable danayer/Vulkan-Git
dnf5 -y copr enable danayer/libdrm-git
dnf5 -y copr enable danayer/linux-firmware-git
dnf5 -y copr enable danayer/mesa-git
dnf5 -y copr enable danayer/virglrenderer-git

# === Swap drivers one-by-one ===
dnf5 upgrade -y \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    mesa-libglapi \
    mesa-libEGL \
    mesa-libGL \
    mesa-libgbm \
    libdrm \
    linux-firmware \
    vulkan-loader \
    virglrenderer

# === Disable COPRs ===
echo "Disabling COPRs..."
dnf5 -y copr disable danayer/Vulkan-Git
dnf5 -y copr disable danayer/libdrm-git
dnf5 -y copr disable danayer/linux-firmware-git
dnf5 -y copr disable danayer/mesa-git
dnf5 -y copr disable danayer/virglrenderer-git
