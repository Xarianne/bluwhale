#!/bin/bash

set -ouex pipefail

### Enable COPRs

# Programs to remove
dnf5 remove -y \
    bazaar

# Programs to install
dnf5 install -y \
    plasma-discover \
    plasma-discover-flatpak

systemctl enable podman.socket
