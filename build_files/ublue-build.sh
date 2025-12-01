#!/bin/bash

set -ouex pipefail

### PACKAGE INSTALLATION
# Assumes a Universal Blue base image with RPM Fusion already enabled.

# Install your applications
dnf5 install -y \
  steam \
  goverlay \
  mangohud \
  input-remapper \
  just

# Faugus Launcher
dnf5 -y copr enable faugus/faugus-launcher
dnf5 -y install faugus-launcher
dnf5 -y copr disable faugus/faugus-launcher

# Topgrade
dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
dnf5 -y copr disable lilay/topgrade

# Install dev packages
dnf5 install -y --setopt=tsflags=noscripts \
  gcc \
  gcc-c++ \
  make \
  pkg-config \
  openssl-devel \
  rust \
  cargo

# Enable a System Unit File
systemctl enable podman.socket
