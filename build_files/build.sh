#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y copr enable danayer/libdrm-git
dnf5 -y copr enable danayer/linux-firmware-git
dnf5 -y copr enable danayer/mesa-git
dnf5 -y copr enable danayer/virglrenderer-git
dnf5 -y copr enable danayer/Vulkan-Git

### Handle specific conflicts and install mesa-git components

# Explicitly remove mesa-va-drivers-freeworld
# This is a common conflict as mesa-git provides its own VA-API drivers.
# `--allowerasing` might handle this, but explicit removal is safer for 'freeworld' packages.
dnf5 -y remove mesa-va-drivers-freeworld || true # Use '|| true' to prevent script from failing if package isn't present for some reason

# Install the core mesa-git, virglrenderer-git, and vulkan-git packages
# `--allowerasing` will handle the 'mesa-filesystem' and other direct replacements.
# `--setopt=install_weak_deps=False` keeps the image clean.
dnf5 install -y \
  mesa-dri-drivers \
  mesa-libgl-devel \
  mesa-vulkan-drivers \
  virglrenderer \
  vulkan-loader \
  vulkan-tools \
  --allowerasing \
  --setopt=install_weak_deps=False

# VA-API and VDPAU drivers from mesa-git:
# (These usually come with mesa-git, but explicit installation can ensure them if missing)
dnf5 install -y \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  --allowerasing \
  --setopt=install_weak_deps=False

### Other system cleanup/config

# Uninstall iBus (as per your original request)
dnf5 -y remove ibus

# Programs to install
dnf5 install -y \
     steam \
     lutris

### Disable COPRs
dnf5 -y copr disable danayer/libdrm-git
dnf5 -y copr disable danayer/linux-firmware-git
dnf5 -y copr disable danayer/mesa-git
dnf5 -y copr disable danayer/virglrenderer-git
dnf5 -y copr disable danayer/Vulkan-Git


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
