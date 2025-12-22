# daFinndus' Dotfiles for hyprland, waybar, eww, and more

## Disclaimer

There are some configuration files that are still hardcoded to my own hardware (for example monitor configurations for hyprland). I also added fallbacks, so other monitors should work as well, but replacing these variables with your own hardware is advised. A list of files to check will be here soon. 

Some other configurations cannot work with your hardware. System information is retrieved differently based on hardware (for example temperatures, audio, etc.).

The dotfiles will work for pulseaudio, amd cpu and gpu, bluetooth and wifi compatible mainboard (my workstation) or for dell notebooks with intel chips (my notebook). 

## Deployment

1. Clone the repo.
2. Remove all affected services (your own hypr, waybar, etc. directories)
3. Execute deploy.sh.
4. Restart services (might even have to restart system).
5. Done. 
