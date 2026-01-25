CONNECTED=$(sudo wg show)

log() {
  echo "[WIREGUARD] $1"
}

if [[ -z "$CONNECTED" ]]; then
  log "Seems you are not connected to home network..."
  sudo wg-quick up kabuki

  notify-send "Wireguard" "Now connected to home network"
  log "Now connected to home VPN."
else
  log "Seems wireguard is already up and running!"
  sudo wg-quick down kabuki

  notify-send "Wireguard" "Disconnected from home network"
  log "Closed connection now."
fi
