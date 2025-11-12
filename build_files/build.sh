#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Install packages
dnf5 install -y \
  steam \
  goverlay \
  mangohud \
  input-remapper \
  just 

# Faugus Launcher, repo + package
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
  cargo \
  akmod-xone

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket