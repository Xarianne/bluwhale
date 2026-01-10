#!/usr/bin/env bash
set -oue pipefail

# 1. Install the Terra Mesa and Extras subrepo release packages
# We use --nogpgcheck here to bootstrap the repositories without key errors
dnf install -y --nogpgcheck \
    terra-release-mesa \
    terra-release-extras \
    terra-release-multimedia