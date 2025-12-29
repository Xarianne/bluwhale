# Bluwhale

A personal Fedora Kinoite image using Universal Blue's template. Not meant for distribution, so if you rebase to this do it at your own risk.

This aims to:

1. Get the latest stable mesa
2. Install proprietary codecs
3. Add native Steam and Faugus Launcher (Lutris is no longer actively developed)
4. Keep KDE and GNOME installations mostly vanilla
5. Add homebrew (via just script)
6. Add metapac (via Distrobox)
7. Give me control over the Fedora base images (with caveats explained later)

## How to install
Rebase from a standard Kinoite or Silverblue image. If you switch desktop environment, (so for example you go from KDE in Kinoite to GNOME in Silverblue) it might look a little odd. You will have to fix icons and themes and such. There is a Flatpak called Mending Wall that attempts to keep the desktop environment settings separate, but I only used it on traditional locally mutable distros, so I don't know how well it works on an atomic variant. 

For Kinoite with my base:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/bluwhale-kinoite:latest
```

For Kinoite with the Universal Blue base (includes Xone):

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/ubluwhale-kinoite:latest
```

For Silverblue with my base:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/bluwhale-silverblue:latest
```

For Silverblue with the Universal Blue base (includes Xone):

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/xarianne/ubluwhale-silverblue:latest
```

The main difference is that the Universal Blue image bases are under their control and might also have an extra few bits (for example Xone support – the Xbox wireless dongle). But any changes are not under my control.

The images I create are fully under my control have everything **I** need.

## What is metapac?
[metapac](https://github.com/ripytide/metapac) is a declarative package manger that works cross distro. It aims to simplify installation and tracking of your packages. As it supports Flatpak, the aim is to use to declaratively handle them.

### Installing metapac
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

## ujust commands
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

### Currently unused: Set up MOK for kernel modules and driver signing
These justfiles exist but will not work currently as the required mokutil, sbsigntools and openssl are not installed. As I don't have to sign anything currently I decided to remove these to lighten the image. For Xone use the ubluwhale images (with the "u" before "bluwhale").

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
