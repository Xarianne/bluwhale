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

If you want to use pinned versions that have software known to work without regressions (at least on my system), then head over to the [releases](https://github.com/Xarianne/bluwhale/releases) page and choose a stable version. While those snapshots do work, only the base Fedora packages, i.e. the packages I didn't add, will receive updates. Using the **latest** tag above however will allow everything to update and will also include changes I have made to the images.

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
