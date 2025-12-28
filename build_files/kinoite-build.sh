#!/bin/bash

set -ouex pipefail

### REPOSITORY SETUP

# Enable Terra repos
dnf5 install -y --nogpgcheck --repofrompath "terra,https://repos.fyralabs.com/terra$(rpm -E %fedora)" terra-release
dnf5 install -y terra-release-extras
dnf5 install -y terra-release-mesa
dnf5 install -y terra-release-multimedia

# Enable RPM Fusion
dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Repository priorities to avoid conflicts
dnf5 config-manager setopt terra.priority=50
dnf5 config-manager setopt terra-mesa.priority=50
dnf5 config-manager setopt rpmfusion-free.priority=90
dnf5 config-manager setopt rpmfusion-nonfree.priority=90

### PACKAGE INSTALLATION

# Gaming tools and utilities
dnf5 install -y \
  goverlay \
  steam \
  input-remapper \
  mangohud \
  vkBasalt \
  just \

# Faugus Launcher, repo + package
dnf5 -y copr enable faugus/faugus-launcher
dnf5 -y install faugus-launcher
dnf5 -y copr disable faugus/faugus-launcher

# Topgrade (via COPR)
dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
dnf5 -y copr disable lilay/topgrade

# Tools
dnf5 install -y \
  docker \
  docker-compose \
  # gcc \
  # gcc-c++ \
  # make \
  # pkg-config \
  # openssl-devel \
  # rust \
  # cargo 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable podman.socket for container workflows
systemctl enable podman.socket
