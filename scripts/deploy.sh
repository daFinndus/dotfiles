#!/bin/bash

set -e # Exit on error
set -u # Exit on undefined variable

HOSTNAME=$(cat /etc/hostname)

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

validate-directory() {
  checking=$1

  if [ ! -d "$checking" ]; then
    error "$checking was not found!"
    mkdir "$checking"
    log "Created $checking, proceeding..."
  else
    log "$checking exists, proceeding..."
  fi
}

# This function will link everything
create-link() {
  target=$1
  option=$2

  if [ -f "$HOME/$target" ] || [ -d "$HOME/$target" ]; then
    log "$target already exists, skipping..."
  else
    log "$target does not exist, proceeding..."

    if [ "$option" == "HOST" ]; then
      ln -s "$HOSTDIR/$target" "$HOME/$target"
    elif [ "$option" == "SHARED" ]; then
      ln -s "$SHARED/$target" "$HOME/$target"
    fi

    log "Sucessfully created symbolic link to $HOME/$target"
  fi
}

main() {
  log "Deploying dotfiles for $HOSTNAME in $DIRECTORY"

  hostname

  validate-directory $SHARED
  validate-directory $HOSTDIR

  log "Going to create symbolic links..."

  # Test it out ony fastfetch only
  get-directories $SHARED
  get-directories $HOSTDIR

  #create-link ".config/eww"
  create-link ".config/fastfetch" SHARED
  #create-link ".config/flameshot"
  #create-link ".config/hypr"
  #create-link ".config/kitty"
  #create-link ".config/mako"
  #create-link ".config/nvim"
  create-link ".config/rmshit.py" SHARED
  create-link ".config/rmshit.yaml" SHARED
  #create-link ".config/rofi"
  #create-link ".config/systemd/user/statusbar.service"
  #create-link ".config/wal"
  #create-link ".config/waybar"
}

main
