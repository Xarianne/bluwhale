# Install my standard flatpaks
install-my-flatpaks:
    #!/usr/bin/env bash
    echo "Installing flatpaks system-wide..."
    flatpak install --system --noninteractive flathub \
        com.vivaldi.Vivaldi \
        com.discordapp.Discord \
        org.localsend.localsend_app \
        com.github.tchx84.Flatseal \
        io.github.flattool.Warehouse \
        com.github.vikdevelop.photopea_app \
        com.vysp3r.ProtonPlus \
        com.obsproject.Studio \
        com.obsproject.Studio.Plugin.InputOverlay \
        com.obsproject.Studio.Plugin.BackgroundRemoval \
        io.podman_desktop.PodmanDesktop \
        org.gnome.DejaDup \
        io.github.radiolamp.mangojuice

    echo "Done! All flatpaks installed system-wide."
