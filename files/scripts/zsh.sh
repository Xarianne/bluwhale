#!/bin/bash
set -oue pipefail

sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd
