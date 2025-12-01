#! /usr/bin/env python3

import os
import sys
import yaml
import shutil

from pathlib import Path

# This is stolen from here:
# https://github.com/lahwaacz/Scripts/blob/master/rmshit.py

# It is modified though

DEFAULT_CONFIG = """
- ~/.adobe                          # Flash crap
- ~/.macromedia                     # Flash crap
- ~/.recently-used                  # Recently used files
- ~/.local/share/recently-used.xbel # Recently used files
- ~/.thumbnails                     # Image thumbnails cache
- ~/.gconfd                         # GNOME configuration daemon
- ~/.gconf                          # GNOME configuration
- ~/.local/share/gegl-0.2           # GEGL library cache
- ~/.FRD/log/app.log                # FRD
- ~/.FRD/links.txt                  # FRD
- ~/.objectdb                       # FRD
- ~/.gstreamer-0.10                 # GStreamer cache
- ~/.pulse                          # PulseAudio
- ~/.esd_auth                       # ESD authentication
- ~/.config/enchant                 # Spell checker cache
- ~/.spicec                         # Contains only log file
- ~/.dropbox-dist                   # Dropbox distribution files
- ~/.parallel                       # GNU Parallel
- ~/.dbus                           # D-Bus session files
- ~/ca2                             # WTF
- ~/ca2~                            # WTF
- ~/.distlib/                       # Contains another empty dir
- ~/.bazaar/                        # Bzr insists on creating files
- ~/.bzr.log                        # Bazaar log file
- ~/.nv/                            # NVIDIA cache
- ~/.viminfo                        # Sometimes created wrongfully
- ~/.npm/                           # NPM cache
- ~/.java/                          # Java cache and temp files
- ~/.swt/                           # Standard Widget Toolkit cache
- ~/.oracle_jre_usage/              # Oracle JRE usage data
- ~/.openjfx/                       # OpenJFX cache
- ~/.org.jabref.gui.JabRefMain/     # JabRef cache
- ~/.org.jabref.gui.MainApplication/ # JabRef cache
- ~/.jssc/                          # Java Simple Serial Connector
- ~/.tox/                           # Cache directory for tox
- ~/.pylint.d/                      # Pylint cache
- ~/.qute_test/                     # Qutebrowser test files
- ~/.QtWebEngineProcess/            # Qt WebEngine cache
- ~/.qutebrowser/                   # Created empty
- ~/.asy/                           # Asymptote cache
- ~/.cmake/                         # CMake cache
- ~/.gnome/                         # GNOME cache
- ~/unison.log                      # Unison log file
- ~/.texlive/                       # TeX Live cache
- ~/.w3m/                           # w3m browser cache
- ~/.subversion/                    # Subversion cache
- ~/nvvp_workspace/                 # Created empty
- ~/.ansible/                       # Ansible cache
- ~/.fltk/                          # FLTK cache
- ~/.vnc/                           # VNC cache
- ~/.local/share/Trash/             # VSCode puts deleted files here
- ~/.cache/yay/                     # Yay AUR helper cache
- ~/.pip/cache/                     # Pip cache (old location)
- ~/.cache/pip/                     # Pip cache
- ~/.node-gyp/                      # Node.js native addon build cache
- ~/.electron-gyp/                  # Electron native addon build cache
- ~/.cache/electron/                # Electron cache
- ~/.cache/chromium/                # Chromium cache
- ~/.cache/google-chrome/           # Google Chrome cache
- ~/.cache/mozilla/                 # Mozilla/Firefox cache
- ~/.cache/mesa_shader_cache/       # Mesa shader cache
- ~/.cache/fontconfig/              # Font cache
- ~/.cache/thumbnails/              # Thumbnail cache
- ~/.gradle/caches/                 # Gradle build cache
- ~/.sbt/boot/                      # SBT boot cache
- ~/.ivy2/cache/                    # Ivy cache
- ~/.m2/repository/                 # Maven repository cache
- ~/.cargo/registry/cache/          # Rust Cargo cache
- ~/.go/pkg/mod/cache/              # Go module cache
- ~/.nuget/packages/                # NuGet package cache
- ~/.dotnet/                        # .NET Core cache
- ~/.rustup/tmp/                    # Rustup temporary files
- ~/.cache/yarn/                    # Yarn package manager cache
- ~/.cache/pnpm/                    # PNPM package manager cache
- ~/.cache/go-build/                # Go build cache
- ~/.cache/bazel/                   # Bazel build cache
- ~/.wine/drive_c/windows/Temp/     # Wine temporary files
- ~/.steam/logs/                    # Steam log files
- ~/.local/share/Steam/logs/        # Steam log files
- ~/.local/share/vulkan/            # Vulkan cache
- ~/.nvm/.cache/                    # Node Version Manager cache
- ~/.composer/cache/                # PHP Composer cache
- ~/.bundle/cache/                  # Ruby Bundle cache
- ~/.gem/specs/                     # Ruby Gem specs cache
- ~/.cpan/build/                    # CPAN build cache
- ~/.cabal/logs/                    # Haskell Cabal logs
- ~/.stack/programs/                # Haskell Stack programs cache
- ~/.cache/yay/                    # Yay AUR helper cache
"""

CONFIG_PATH = Path(os.getenv("XDG_CONFIG_HOME", Path.home() / ".config")) / "rmshit.yaml"

# Format size function to convert bytes to human-readable format
def format_size(size: float) -> str:
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if size < 1024:
            return f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} PiB"

# Get directory size function to calculate total size of files in a directory
def get_dir_size(path: Path) -> int:
    total = 0
    try:
        if path.is_file():
            return path.stat().st_size
        for p in path.rglob("*"):
            try:
                if p.is_file():
                    total += p.stat().st_size
            except (OSError, FileNotFoundError):
                continue
    except Exception:
        pass
    return total

# Load configuration function to read paths from the config file 
def load_config() -> list[Path]:
    if not CONFIG_PATH.exists():
        CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
        CONFIG_PATH.write_text(DEFAULT_CONFIG.strip() + "\n")

    try:
        raw = yaml.safe_load(CONFIG_PATH.read_text()) or []
    except yaml.YAMLError as e:
        sys.exit(f"YAML parse error in {CONFIG_PATH}: {e}")

    return [Path(os.path.expanduser(str(p))) for p in raw]

# Function to prompt user for yes/no input
def yesno(question: str, default="n") -> bool:
    prompt = f"{question} (y/[n]) " if default == "n" else f"{question} ([y]/n) "
    ans = input(prompt).strip().lower()
    if not ans:
        ans = default
    return ans.startswith("y")

def rmshit():
    junk_paths = load_config()
    found = []
    total_size = 0

    print("Scanning for junk files...")

    for p in junk_paths:
        expanded = list(sorted(p.parent.glob(p.name))) if "*" in p.name else [p]
        for path in expanded:
            if path.exists():
                size = get_dir_size(path)
                total_size += size
                found.append((path, size))

    if not found:
        print("No junk found.")
        return

    print("\nFound junk files/directories:")
    for path, size in found:
        print(f"  {path}  ({format_size(size)})")
    print(f"\nTotal size: {format_size(total_size)}")

    if not yesno("Remove all?", default="n"):
        print("No file removed.")
        return

    freed = 0
    for path, size in found:
        try:
            if path.is_file() or path.is_symlink():
                path.unlink(missing_ok=True)
            else:
                shutil.rmtree(path, ignore_errors=True)
            freed += size
        except Exception as e:
            print(f"Failed to delete {path}: {e}")

    print(f"\nCleaned up {format_size(freed)} in total.")

if __name__ == "__main__":
    rmshit()
