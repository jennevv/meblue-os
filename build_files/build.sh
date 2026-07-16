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
  cascadia-code-nf-fonts
  sddm
  powertop
  rclone
  restic
  # hyprland related
  hyprland
  xdg-desktop-portal-hyprland
  hyprpolkitagent # system-wide privileges
  qt5-qtwayland
  qt6-qtwayland
  mako      # notifications daemon
  waybar    # status bar
  cliphist  # clipboard history
  hyprpaper # wallpaper manager
  hyprlock  # screen locker
  hypridle  # idle manager
  wlogout   # logout, suspend, restart,...
  hyprshot  # screenshots
  nwg-look  # setting gtk themes
  ## setting qt themes
  qt5ct
  qt6ct
  kvantum
)

# copr required for ghostty
dnf -y copr enable scottames/ghostty
dnf -y copr enable sdegler/hyprland
dnf -y copr enable tofik/nwg-shell
dnf5 install -y "${PACKAGES[@]}"
dnf -y copr disable scottames/ghostty
dnf -y copr disable sdegler/hyprland
dnf -y copr disable tofik/nwg-shell

# enable podman
systemctl enable podman.socket

# enable brew
systemctl preset brew-setup.service &&
  systemctl preset brew-update.timer &&
  systemctl preset brew-upgrade.timer
