# uosc & thumbfast Auto-Installer for MPV

Automatically installs and configures [uosc](https://github.com/tomasklaen/uosc) (Minimalist UI) and [thumbfast](https://github.com/po5/thumbfast) (High-performance thumbnails) for MPV on Linux.

## Features

* ✅ **Auto-installs dependencies** (`mpv`, `jq`)
* ✅ **Installs `uosc`** (Latest Release)
* ✅ **Installs `thumbfast`** (Latest Master)
* ✅ **Auto-Configures** `mpv.conf` and `input.conf` with optimal settings
* ✅ **Destructive Updates:** Overwrites script configs with the latest defaults to ensure compatibility

## Quick Start

```bash
curl -O [https://raw.githubusercontent.com/quantavil/mpv-usoc/main/install-uosc.sh](https://raw.githubusercontent.com/quantavil/mpv-usoc/main/install-uosc.sh)
chmod +x install-uosc.sh
./install-uosc.sh

```

## What It Does

1. **Dependencies:** Installs `mpv` and `jq` (via `dnf`) if missing.
2. **uosc:** Downloads the latest release, installs scripts/fonts, and overwrites `uosc.conf`.
3. **thumbfast:** Downloads the latest Lua script and config, installing them to `~/.config/mpv/scripts/thumbfast`.
4. **Config:**
* Appends required settings to `mpv.conf` (e.g., disables default OSC).
* Appends useful keybindings to `input.conf`.



## Keybindings Added

* `p` — Open uosc menu / playlist
* `i` — Toggle color inversion (Video Filter)

## Update

To update **uosc** or **thumbfast**, simply run the script again.

> **⚠️ Warning:** This script overwrites `script-opts/uosc.conf` and `script-opts/thumbfast.conf` with the default versions from GitHub. **Any manual customizations to these two specific files will be lost.**

```bash
./install-uosc.sh

```

## Uninstall

**Remove scripts only:**

```bash
rm -rf ~/.config/mpv/scripts/uosc
rm -rf ~/.config/mpv/scripts/thumbfast
rm -rf ~/.config/mpv/fonts/uosc*
rm ~/.config/mpv/script-opts/uosc.conf
rm ~/.config/mpv/script-opts/thumbfast.conf

```

**Remove MPV completely:**

```bash
sudo dnf remove mpv
rm -rf ~/.config/mpv ~/.cache/mpv ~/.local/state/mpv ~/.local/share/mpv

```

## Troubleshooting

* **Thumbnails not showing:** Ensure `mpv` is compiled with support for the video format you are playing.
* **UI overlaps:** Check `~/.config/mpv/mpv.conf` to ensure `osc=no` is present.
* **Non-Fedora systems:** The script uses `dnf`. For Debian/Arch, manually install `mpv` and `jq` before running, or modify the script.

## Customization

After installation, you can customize settings here (note that running the installer again will reset these):

* **uosc:** `~/.config/mpv/script-opts/uosc.conf`
* **thumbfast:** `~/.config/mpv/script-opts/thumbfast.conf`

## Credits

* [uosc](https://github.com/tomasklaen/uosc) by tomasklaen
* [thumbfast](https://github.com/po5/thumbfast) by po5
* [MPV Media Player](https://mpv.io/)

---

**License:** MIT | **Note:** Unofficial installer for Linux 
