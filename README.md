# bluwhale &nbsp; [![bluebuild build badge](https://github.com/xarianne/bluweird/actions/workflows/build.yml/badge.svg)](https://github.com/xarianne/bluweird/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

This is a personal Fedora Silverblue build, including my gaming packages of choice, the latest stable mesa from the Terra repos, [xone](https://github.com/dlundqvist/xone) (with secure boot support, courtesy of Universal Blue) and ntsync turned on out-of-the-box. It also has Hyprland with the Dank Material Shell. AMD only. Not fit for general use, so if you try this, do it at your own risk. Instructions are here for my benefit more than anything.

## Silverblue... with Hyprland?
Yes it still has GNOME, but it also has Hyprland. Dank Material Shell is designed so that it does not interfere with other Desktop Environments (too much). Icons will change for both. If you want to be extra sure, download Mending Wall from Flatpak before making changes to either.

## What's installed?
Here is the [package list](https://github.com/Xarianne/bluwhale/tree/main/recipes).

## Why do you need Terra?
Terra provides a lot of extra packages not shipped by Fedora. They also have the latest stable mesa, as Fedora holds back on them for stability. They also provide proprietary codecs. For more information have a look at [their documentation](https://developer.fyralabs.com/terra/faq).

## Secure boot support
Fedora suports secure boot out-of-the-box but when kernel modules are added, such as xone, they also need to be signed. To make sure xone works, you can use Universal Blue's own key by typing `ujust enroll-secure-boot`. This will sign the module with their key and prompt you to set a password. The suggestion is to use universalblue. When rebooting, you will be shown an MOK enrollment screen. Go through the steps to enroll the key then reboot. The Xbox wireless dongle should now work.

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/bluwhale:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/xarianne/bluwhale:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/xarianne/bluweird
```
