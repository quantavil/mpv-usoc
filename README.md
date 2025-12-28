# mpv-usoc

This is an Automated installer/updater for [uosc](https://github.com/tomasklaen/uosc), the minimal UI for mpv.

## Usage
download install_uosc.sh

```bash
chmod +x install_uosc.sh
./install_uosc.sh
```

## Configuration

The script appends the following to your mpv config if not present:

**`~/.config/mpv/mpv.conf`**

* Disables default OSD/OSC.
* Enables quit position saving.

**`~/.config/mpv/input.conf`**
| Key | Action |
| :--- | :--- |
| `p` | Open uosc Playlist/Files menu |
| `i` | Toggle Invert Colours (Negate) |

```

```
