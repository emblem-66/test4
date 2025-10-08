#!/bin/bash
set -xeuo pipefail

# hardware/drivers
#dnf install -y \
#    kernel-modules-extra \
#    iwlwifi-mvm-firmware \
#    alsa-sof-firmware \
#    blueman \
#    NetworkManager-wifi \
#    NetworkManager-openvpn-gnome \
#    powertop \
#    wpa_supplicant

# shell tools and development
#dnf install -y \
#    cyrus-sasl-plain \
#    fpaste \
#    git \
#    glibc-langpack-de \
#    glibc-langpack-en \
#    isync \
#    krb5-workstation \
#    man-db \
#    mtr \
#    mutt  \
#    neovim \
#    nmap-ncat \
#    restic \
#    rsync \
#    strace \
#    syncthing \
#    systemd-container \
#    toolbox \
#    tree \
#    w3m \
#    wget

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# GNOME desktop
dnf install -y \
    gdm \
    gnome-shell \
    nautilus \
    ptyxis \
    gnome-disk-utility \
    adw-gtk3-theme

# graphical target
systemctl set-default graphical.target

# desktop plumbing/apps
dnf install -y \
    flatpak

#dnf remove -y \

#rpm -qa 'qemu-user-static*' | xargs dnf remove -y

#dnf clean all

dnf install -y --allowerasing ffmpeg libavcodec-freeworld mesa*freeworld steam

#rpm -e --verbose dnf dnf-data python3-dnf

### Config files
# repo - tailscale
curl --create-dirs -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
# repo - morewaita icons
curl --create-dirs -o /etc/yum.repos.d/morewaite.repo https://copr.fedorainfracloud.org/coprs/trixieua/morewaita-icon-theme/repo/fedora-rawhide/trixieua-morewaita-icon-theme-fedora-rawhide.repo
# justfile
curl --create-dirs -o /usr/share/just/justfile https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_share_just_justfile
# systemd - bootc
curl --create-dirs -o /usr/lib/systemd/system/bootc-update.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_bootc-update.service
curl --create-dirs -o /usr/lib/systemd/system/bootc-update.timer https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_bootc-update.timer
# systemd - flatpak
curl --create-dirs -o /usr/lib/systemd/system/flatpak-setup.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_flatpak-setup.service
curl --create-dirs -o /usr/lib/systemd/system/flatpak-update.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_flatpak-update.service
curl --create-dirs -o /usr/lib/systemd/system/flatpak-update.timer https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_flatpak-update.timer
curl --create-dirs -o /usr/lib/systemd/system/flatpak-packages.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_flatpak-packages.service
# systemd - brew
curl --create-dirs -o /usr/lib/systemd/system/brew-setup.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_brew-setup.service
curl --create-dirs -o /usr/lib/systemd/system/brew-update.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_brew-update.service
curl --create-dirs -o /usr/lib/systemd/system/brew-packages.service https://raw.githubusercontent.com/emblem-66/bootc-config/refs/heads/main/_usr_lib_systemd_system_brew-packages.service

### Packages
# Tailscale
dnf install -y tailscale && rm -rf /etc/yum.repos.d/tailscale.repo
# Just
dnf install -y just
# morewaita icons
dnf install -y morewaita-icon-theme && rm -rf /etc/yum.repos.d/morewaite.repo
# adwaita theme
dnf install -y adw-gtk3-theme 
# Remove Firefox
dnf remove -y firefox*
# Remove unwanted Fedora stuff
dnf remove -y \
    virtualbox-guest-additions \
    fedora-chromium-config* \
    fedora-bookmarks \
    fedora-flathub-remote \
    fedora-third-party \
# Remove GNOME stuff
dnf remove -y \
    gnome-shell-extension* \
    gnome-tour \
    yelp* \
    gnome-software* \
    virtualbox-guest-additions \
    malcontent-control \
# bulk remove
rpm -qa 'qemu-user-static*' | xargs dnf remove -y
# Cockpit
dnf install -y cockpit cockpit-podman
# piper
dnf install -y piper

### SystemD
# tailscale
systemctl enable tailscaled.service
systemctl enable sshd.service
# bootc
systemctl enable bootc-update.timer
# flatpak
systemctl enable flatpak-setup.service
systemctl enable flatpak-update.service
systemctl enable flatpak-update.timer
systemctl enable flatpak-packages.service
# brew
systemctl enable brew-setup.service
systemctl enable brew-update.service
systemctl enable brew-packages.service
# mask
systemctl mask flatpak-add-fedora-repos.service
systemctl mask fedora-third-party-refresh.service
# failing systemd-remount-fs.service
systemctl mask systemd-remount-fs.service
# cockpit
systemctl enable cockpit.socket
# piper
systemctl enable ratbagd.service
