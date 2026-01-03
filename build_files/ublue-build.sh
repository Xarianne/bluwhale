#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## Gaming tools and utilities
dnf5 install -y \
  goverlay \
  steam \
  input-remapper \
  mangohud \
  vkBasalt \
  just \
  protontricks

# Faugus Launcher, repo + package
dnf5 -y copr enable faugus/faugus-launcher
dnf5 -y install faugus-launcher
#dnf5 -y copr disable faugus/faugus-launcher

##################
# SYSTEM UTILITIES
##################

## Scx-manager from CachyOS and Sched-ex
# COPR
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
# Scheduler CLI and GUI
dnf5 install -y \
  scx-scheds \
  scx-tools \
  scx-manager

# Topgrade (via COPR)
dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
#dnf5 -y copr disable lilay/topgrade

# Maintenance
dnf5 install -y \
  greenboot \
  greenboot-default-health-checks \
  bees

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable podman.socket for container workflows
systemctl enable podman.socket
