# Bluwhale

A personal Fedora Kinoite image using Universal Blue's template. Not meant for distribution, so if you rebase to this do it at your own risk.

This aims to:

1. Get newer mesa
2. Install proprietary codecs
3. Add a couple of gaming apps
4. Add just what I need for my system
5. Add homebrew (via just script)
6. Add metapac (via just script)

What is [metapac](https://github.com/ripytide/metapac)? It's a declarative package manger that replaces a number of other package managers. It aims to simplify installation and tracking of your packages. As it supports Flatpak, the aim is to use to declaratively handle flatpaks.

Rebase from a standard kinoite image: 

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/bluwhale:latest
```

This repo can produce two images (currently this is a manual process but will automate in future): one with a base Kinoite image from Fedora, the other one starts from the Universal Blue image with batteries included. 

The Fedora Kinoite version doesn't have proprietary codecs and has slightly older mesa by default (Fedora holds back on mesa until they are absolutely sure it doesn't contain a regression). So I have manually added the proprietary codecs and more up-to-date mesa from the Terra repos. 

The Universal Blue image has this already included and doesn't need me to add the extra repos. This means they do the troubleshooting with possible conflicts. However if they change what they are including in their image, it will also affect my image without me necessarily knowing. So this is here as a back up in case my build breaks and I need something to work right now.

Having said that, the entire point of having the cloud-native approach is that nothing should reach my machine until the images build successfully, but I figured I'd still have this back-up option just in case.

## Installing metapac
Use Distrobox. Initially I was including the rust dependencies in the image, but metapac can actually be run from Distrobox and it will still be able to install flatpaks on the host. Install something like Distroshelf from Flathub, install a Fedora Distrobox, then install rust in that box `sudo dnf install rust`. 

Then use `cargo install metapac` and add cargo to the PATH in both Distrobox and the host.

The metapac folder in this repo can then be moved as is into `~/.config`.

For bash:
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

```
For zsh
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
```

## Current ujust commands
### Virtualization
```bash
ujust setup-virtualization
```
Sets up Virtual Machine Manager via Flatpak so it runs under the user. Also enables USB passthrough.

Ohter commans are also:
```bash
ujust check-virtualization
```

```bash
ujust remove-virtualization
```

### Install Homebrew

```bash
ujust setup-brew
```

### Set up MOK for kernel modules and driver signing

```bash
ujust setup-mok
```

Creates ~/.mok-keys and, if keys are absent, writes an OpenSSL cnf and generates a long-lived 2048‑bit RSA x509 cert:

    MOK.priv (private key), MOK.der (public cert, DER), MOK.pem (public cert, PEM).

Runs sudo mokutil --import ~/.mok-keys/MOK.der so the key is added to the MOK enrollment list, requiring a reboot to complete.

Prints step‑by‑step instructions for using the shim “MOK manager” UI on next boot to enroll the key and then suggests check-mok and sign-module as follow‑ups.

```bash
ujust check-mok
```

```bash
ujust sign-module
```
- Identify the installed .ko with `modinfo -n <module>` or by path under `/lib/modules/$(uname -r)/`.
- Run sign-module with that path as shown above.

```bash
ujust sign-xone
```
Installs the Xone module after installation (the Xbox Wireless Dongle firmware).
