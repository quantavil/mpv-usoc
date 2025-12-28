# uosc Auto-Installer for MPV

Automatically installs and configures [uosc](https://github.com/tomasklaen/uosc) - a modern UI for MPV media player on Fedora-based systems.

## Features

- ✅ Auto-installs dependencies (mpv, jq)
- ✅ Downloads latest uosc release
- ✅ Smart extraction with verification
- ✅ Idempotent - safe to re-run
- ✅ Configures MPV with optimal settings

## Quick Start

```bash
curl -O https://raw.githubusercontent.com/quantavil/mpv-usoc/main/install-uosc.sh
chmod +x install-uosc.sh
./install-uosc.sh
```

## What It Does

1. Installs MPV and jq if missing
2. Downloads latest uosc from GitHub
3. Installs scripts, fonts, and config to `~/.config/mpv/`
4. Configures MPV settings (disables default OSC)
5. Adds useful keybindings:
   - `p` - Open uosc menu
   - `i` - Toggle color inversion

## Update

Just run the script again:
```bash
./install-uosc.sh
```

## Uninstall

**Remove uosc only:**
```bash
rm ~/.config/mpv/scripts/uosc.lua
rm -rf ~/.config/mpv/fonts/uosc*
rm ~/.config/mpv/script-opts/uosc.conf
```

**Remove MPV completely:**
```bash
sudo dnf remove mpv
rm -rf ~/.config/mpv ~/.cache/mpv ~/.local/state/mpv ~/.local/share/mpv
```

## Troubleshooting

- **UI doesn't appear:** Check `~/.config/mpv/mpv.conf` has `osc=no`
- **Script fails:** Verify internet connection and GitHub access
- **Non-Fedora systems:** Replace `dnf` with your package manager

## Customization

Edit uosc settings:
```bash
~/.config/mpv/script-opts/uosc.conf
```

See [uosc documentation](https://github.com/tomasklaen/uosc#options) for options.

## Links

- [uosc Repository](https://github.com/tomasklaen/uosc)
- [MPV Documentation](https://mpv.io/manual/stable/)

## Credits

- [uosc](https://github.com/tomasklaen/uosc) by tomasklaen
- [MPV Media Player](https://mpv.io/)

---

**License:** MIT | **Note:** Unofficial installer for Linux-based systems
