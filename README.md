# Dotfiles for hyprland, waybar, eww, and more

## Disclaimer

There are some configuration files that are still hardcoded to my own hardware (for example monitor configurations for hyprland). I also added fallbacks, so other monitors should work as well, but replacing these variables with your own hardware is advised. A list of files to check will be here soon. 

Some other configurations cannot work with your hardware. System information is retrieved differently based on hardware (for example temperatures, audio, etc.). 

## Deployment

Currently this doesn't work, I have to update the deploy script.

1. Clone the repo.
2. Remove all affected services (your own hypr, waybar, etc. directories)
3. Careful, this will overwrite your config directories: Execute deploy.sh.
4. Restart services (might even have to restart system).
5. Done. 
