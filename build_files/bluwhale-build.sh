#!/bin/bash

set -ouex pipefail

### REPOSITORY SETUP

# Enable Terra repos
dnf5 install -y --nogpgcheck --repofrompath "terra,https://repos.fyralabs.com/terra$(rpm -E %fedora)" terra-release
dnf5 install -y terra-release-extras
dnf5 install -y terra-release-mesa
dnf5 install -y terra-release-multimedia

######################
# PACKAGE INSTALLATION
######################

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
  greenboot-default-health-checks

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable podman.socket for container workflows
systemctl enable podman.socket

# Enable greenboot services
systemctl enable greenboot-healthcheck.service
