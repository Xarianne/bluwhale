#!/bin/bash

set -ouex pipefail

### Enable COPRs
# example dnf5 -y copr enable danayer/libdrm-git

# Uninstall iBus
dnf5 -y remove ibus

# Programs to install (Steam and Lutris)
dnf5 install -y \
  steam \
  lutris

### Disable COPRs

# systemctl enable podman.socket
