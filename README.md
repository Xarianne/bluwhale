# bluwhale &nbsp; [![bluebuild build badge](https://github.com/xarianne/bluweird/actions/workflows/build.yml/badge.svg)](https://github.com/xarianne/bluweird/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on BlueBuild templates.

This is a personal Fedora Atomic build, including my gaming packages of choice and the latest stable mesa from the Terra repos. AMD only. Not fit for general use, so if you try this, do it at your own risk. Instructions are here for my benefit more than anything.

## What's installed?
Here is the [package list](https://github.com/Xarianne/bluwhale/tree/main/recipes).

## Why do you need Terra?
Terra provides a lot of extra packages not shipped by Fedora. They also have the latest stable mesa, as Fedora holds back on them for stability. They also provide proprietary codecs. For more information have a look at [their documentation](https://developer.fyralabs.com/terra/faq).

## Secure boot support
Fedora suports secure boot out-of-the-box but when kernel modules are added, such as xone, they also need to be signed. To make sure xone works, you can use Universal Blue's own key by typing `ujust enroll-secure-boot`. This will sign the module with their key and prompt you to set a password. The suggestion is to use universalblue. When rebooting, you will be shown an MOK enrollment screen. Go through the steps to enroll the key then reboot. The Xbox wireless dongle should now work.

## Installation

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/bluwhale-kde:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/xarianne/bluwhale-gnome:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## First launch to-dos
Run just scripts. If making a new user after installation, these won't be necessary, but as I am rebasing to this, the user will already exist, and these will bring me back up to speed quickly.

Set up the Fish shell:
```bash
ujust set-fish-shell
```

For additional kernel modules, enable secure boot (only works with Ublue's base image)
```bash
ujust enroll-secure-boot
```

## Flatpaks
They are handled by Homebrew. My Brewfile is saved [here](https://github.com/Xarianne/fedora-dotfiles). Download the homebrew folder into your home folder. This only works with my Fish aliases and functions, which are also in the dotfiles repo.

Checks if any packages are missing from the Brewfile but doesn't install anything:
```bash
brew-missing
```

Checks if there are extra packages not in the Brewfile but doesn't uninstall anything:
```bash
brew-extra
```

Installs packages from the list without touching what's already installed in the system:

```bash
brew-install
```

Installs packages and remove anything that is not in the list:
```bash
brew-sync
```

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/xarianne/bluwhale
```
