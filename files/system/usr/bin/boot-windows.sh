#!/usr/bin/bash
set -euo pipefail

# Find the Windows Boot Manager entry
boot_number=$(
  efibootmgr | awk '/Windows Boot Manager/ { sub("^Boot","",$1); sub("\\*","",$1); print $1; exit }'
)

if [ -z "$boot_number" ]; then
  echo "Cannot find Windows boot in EFI, exiting"
  exit 1
fi

echo "Setting next boot to Windows (Boot$boot_number)..."
sudo efibootmgr -n "$boot_number" && reboot
