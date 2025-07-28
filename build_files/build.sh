#!/bin/bash

set -ouex pipefail

### Enable COPRs
# example dnf5 -y copr enable danayer/libdrm-git

# Programs to remove
dnf5 remove -y \
    bazaar

# Programs to install
dnf5 install -y \
    plasma-discover

### Disable COPRs

systemctl enable podman.socket
