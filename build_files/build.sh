#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
PACKAGES=(
  ghostty
  wireplumber
  pipewire
  cascadia-code-nf-fonts
  sddm
  powertop
  rclone
  restic
  # hyprland related
  hyprland
  xdg-desktop-portal-hyprland
  polkit-kde-agent # system-wide privileges
  qt5-wayland
  qt6-wayland
  dunst     # notifications daemon
  waybar    # status bar
  cliphist  # clipboard history
  swww      # wallpaper manager
  hyprlock  # screen locker
  hypridle  # idle manager
  wlogout   # logout, suspend, restart,...
  grimblast # screenshots
  nwg-look  # setting gtk themes
  ## setting qt themes
  qt5ct
  qt6ct
  kvantum
)

# copr required for hyprland
dnf5 -y copr enable ublue-os/staging
dnf5 install -y "${PACKAGES[@]}"
dnf5 -y copr disable ublue-os/staging

# enable podman
systemctl enable podman.socket

# enable brew
systemctl preset brew-setup.service &&
  systemctl preset brew-update.timer &&
  systemctl preset brew-upgrade.timer
