#!/bin/bash

set -ouex pipefail

### Terra and RPM Fusion Setup with Codec Installation
# This script handles the Terra/RPM Fusion repository configuration
# and installs proprietary multimedia codecs

# Enable Terra repos
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Enable Terra extras
dnf5 install -y terra-release-extras

# Enable Terra Mesa stream
dnf5 install -y terra-mesa

# Enable Terra Multimedia
dnf5 install -y terra-multimedia

# Enable RPM Fusion
dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Set repository priorities (lower = higher priority)
# Terra gets priority for Mesa to avoid conflicts
echo "priority=50" >> /etc/yum.repos.d/terra.repo
echo "priority=50" >> /etc/yum.repos.d/terra-mesa.repo
echo "priority=90" >> /etc/yum.repos.d/rpmfusion-free.repo
echo "priority=90" >> /etc/yum.repos.d/rpmfusion-nonfree.repo

# Install proprietary codecs from RPM Fusion
# --allowerasing prevents Terra/RPM Fusion conflicts
dnf5 install -y --allowerasing \
  gstreamer1-plugins-ugly \
  gstreamer1-plugins-bad-freeworld \
  gstreamer1-plugin-openh264 \
  gstreamer1-libav \
  libavcodec-freeworld \
  ffmpeg
