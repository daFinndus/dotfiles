#!/bin/bash

set -e # Exit on error
set -u # Exit on undefined variable

HOSTNAME=$(cat /etc/hostname)

THEMES="/usr/share/icons"

DIRECTORY="$HOME/Dotfiles"
SHARED="$DIRECTORY/shared"
HOSTDIR="$DIRECTORY/$HOSTNAME"

log() {
  log=$1

  echo "[CONF-DEPLOY] $log"
}

error() {
  error=$1

  echo "[CONF-DEPLOY] ERROR: $error" >&2
}

# This function fetches the hostname from /etc/cat
hostname() {
  if [ -n "$HOSTNAME" ]; then
    log "Detected hostname: $HOSTNAME"
  fi

  read -p "[CONF-DEPLOY] Is your hostname $HOSTNAME? [y/N] " host_confirm

  if [ "$(echo ${host_confirm,})" == "y" ]; then
    log "Variable is confirmed"
  else
    log "Hostname was wrong"
    exit 1
  fi
}

validate_directory() {
  checking=$1

  if [ ! -d "$checking" ]; then
    log "$checking was not found!"
    mkdir "$checking"
    log "Created $checking, proceeding..."
  else
    log "$checking exists, proceeding..."
  fi
}

# This function will link everything
create_link() {
  target=$1
  option=$2

  if [ -e "$HOME/$target" ] || [ -L "$HOME/$target" ]; then
    log "$target already exists, skipping..."
  else
    log "$target does not exist, proceeding..."

    mkdir -p "$(dirname "$HOME/$target")"

    if [ "$option" == "HOST" ]; then
      ln -s "$HOSTDIR/$target" "$HOME/$target"
    elif [ "$option" == "SHARED" ]; then
      ln -s "$SHARED/$target" "$HOME/$target"
    fi

    log "Sucessfully created symbolic link to $HOME/$target"
  fi
}

link_themes() {
  if [ -e "$THEMES" ] || [ -L "$THEMES " ]; then
    log "$THEMES already exists, skipping..."
  else
    log "$THEMES does not exist, proceeding..."
    sudo ln -s "$DIRECTORY/icons" "$THEMES"

    log "Successfully created symbolic link to $THEMES"
  fi
}

main() {
  log "Deploying dotfiles for $HOSTNAME in $DIRECTORY"

  hostname

  validate_directory $SHARED
  validate_directory $HOSTDIR

  log "Going to create symbolic links..."

  # Create links for eww
  create_link ".config/eww" HOST

  # Create links for hyprland
  create_link ".config/hypr/hyprland.conf" SHARED
  create_link ".config/hypr/hyprlock.conf" SHARED
  create_link ".config/hypr/hyprpaper.conf" SHARED
  create_link ".config/hypr/scripts" SHARED

  create_link ".config/hypr/autostart.conf" HOST
  create_link ".config/hypr/binds.conf" HOST
  create_link ".config/hypr/input.conf" HOST
  create_link ".config/hypr/monitors.conf" HOST
  create_link ".config/hypr/variables.conf" HOST
  create_link ".config/hypr/windowrules.conf" HOST

  # Create links for waybar
  create_link ".config/waybar" HOST

  # Create links for small apps
  create_link ".config/systemd/user/statusbar.service" SHARED

  create_link ".config/btop" SHARED
  create_link ".config/fastfetch" SHARED
  create_link ".config/rmshit.py" SHARED
  create_link ".config/rmshit.yaml" SHARED
  create_link ".config/flameshot" SHARED
  create_link ".config/kitty" SHARED
  create_link ".config/mako" SHARED
  create_link ".config/nvim" SHARED
  create_link ".config/rofi" SHARED
  create_link ".config/wal" SHARED

  # This one is kinda special, requires sudo, for THEMES
  # link_themes

  log "Everything done!"
}

main
