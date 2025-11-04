#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Enable Terra repos
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Enable Terra extras
dnf5 install -y terra-release-extras

# Enable Terra Mesa stream
dnf5 config-manager setopt terra-mesa.enabled=1

# Enable RPM Fusion
dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Set repository priorities (lower = higher priority)
echo "priority=50" >> /etc/yum.repos.d/terra.repo
echo "priority=50" >> /etc/yum.repos.d/terra-mesa.repo
echo "priority=90" >> /etc/yum.repos.d/rpmfusion-free.repo
echo "priority=90" >> /etc/yum.repos.d/rpmfusion-nonfree.repo

# this installs a package from fedora repos
dnf5 install -y \
steam
# lutris \
# mangohud \
# input-remapper \
# kvantum

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
