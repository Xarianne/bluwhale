#!/bin/bash

set -ouex pipefail

### REPOSITORY SETUP

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

# Proprietary multimedia codecs and essential tools
dnf5 install -y --allowerasing \
  gstreamer1-plugins-ugly \
  gstreamer1-plugins-bad-freeworld \
  gstreamer1-plugin-openh264 \
  gstreamer1-libav \
  libavcodec-freeworld \
  ffmpeg

# Gaming tools and utilities
dnf5 install -y \
  steam \
  input-remapper \
  just

##------------------------------------------------##
# GOverlay runtime + build dependencies
# Fedora's package is out of date
# 1) Install GOverlay build + runtime deps (add this to your existing dnf5 installs)
dnf5 install -y \
  mangohud \
  mesa-demos \
  vulkan-tools \
  vkBasalt \
  git \
  qt6pas \
  lazarus

# 2) Build and install GOverlay
git clone https://github.com/benjamimgois/Goverlay.git /tmp/Goverlay
pushd /tmp/Goverlay
make
sudo make install
popd
rm -rf /tmp/Goverlay

# 3) Trim only Pascal build deps, keep Rust + cargo for metapac
dnf5 remove -y lazarus qt6pas
##------------------------------------------------##

# Faugus Launcher (via COPR)
dnf5 -y copr enable faugus/faugus-launcher
dnf5 -y install faugus-launcher
dnf5 -y copr disable faugus/faugus-launcher

# Topgrade (via COPR)
dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
dnf5 -y copr disable lilay/topgrade

# Development tools
dnf5 install -y --setopt=tsflags=noscripts \
  gcc \
  gcc-c++ \
  make \
  pkg-config \
  openssl-devel \
  rust \
  cargo

# Enable podman.socket for container workflows
systemctl enable podman.socket
