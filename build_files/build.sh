#!/bin/bash

set -ouex pipefail

### Enable COPRs
# Enable all danayer COPRs you need for full mesa-git stack
dnf5 -y copr enable danayer/libdrm-git
dnf5 -y copr enable danayer/linux-firmware-git
dnf5 -y copr enable danayer/mesa-git
dnf5 -y copr enable danayer/virglrenderer-git
dnf5 -y copr enable danayer/Vulkan-Git

### Handle specific conflicts and install mesa-git components

# Explicitly remove mesa-va-drivers-freeworld
# This is a common conflict as mesa-git provides its own VA-API drivers.
# Using '|| true' to prevent the script from failing if the package isn't present
dnf5 -y remove mesa-va-drivers-freeworld || true

# Now, install the core mesa-git, virglrenderer-git, and vulkan-git packages
dnf5 install -y \
  mesa-dri-drivers \
  mesa-libGL-devel \
  mesa-vulkan-drivers \
  virglrenderer \
  vulkan-loader \
  vulkan-tools \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  --repo=copr:copr.fedorainfracloud.org:danayer:mesa-git \
  --repo=copr:copr.fedorainfracloud.org:danayer:Vulkan-Git \
  --repo=copr:copr.fedorainfracloud.org:danayer:virglrenderer-git \
  --allowerasing \
  --setopt=install_weak_deps=False

### Other system cleanup/config

# Uninstall iBus (as per your original request)
dnf5 -y remove ibus

# Programs to install (Steam and Lutris)
dnf5 install -y \
  steam \
  lutris

### Disable COPRs to ensure a clean final image (important!)
# Disable without the :ml suffix
dnf5 -y copr disable danayer/libdrm-git
dnf5 -y copr disable danayer/linux-firmware-git
dnf5 -y copr disable danayer/mesa-git
dnf5 -y copr disable danayer/virglrenderer-git
dnf5 -y copr disable danayer/Vulkan-Git

#### Example for enabling a System Unit File (already present, uncomment if desired)
# systemctl enable podman.socket
