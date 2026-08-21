# BarInFoo

BarInFoo drives a custom Waybar module with short status text, such as keybind hints.

You can pick a saved line through fuzzel and send it to the bar. There is also an optional niri path: query the focused window, match it against `hints.json` when possible, otherwise show the window title, then refresh Waybar. The fuzzel picker is meant to be enabled. The niri poll and its refresh bind ship with the repo but stay off until you uncomment them.

## Requirements

This project needs:

- [niri](https://github.com/YaLTeR/niri)
- [fuzzel](https://codeberg.org/dnkl/fuzzel)
- [waybar](https://github.com/Alexays/Waybar)

The scripts also use `bash` and `jq`.

## Usage

Clone or copy this repository, then point Waybar and niri at the scripts in `bin/`. Replace `$BARINFOO` below with the absolute path of your clone.

**1. Edit snippets** in `hints.json`.

- `default` is shown when nothing has been picked yet.
- `snippets[].text` is the line Waybar displays after you select it in fuzzel.
- `snippets[].search` is extra filter text for fuzzel.
- `match_app_id` and `match_title` are only used by `bin/sync-from-niri.sh`.

**2. Wire Waybar** in `~/.config/waybar/config.jsonc`. Put `custom/text_field_1` in `modules-left` (or another module list) and give it:

```jsonc
"custom/text_field_1": {
    "exec": "$BARINFOO/bin/waybar-hint.sh",
    "return-type": "json",
    "format": "{text}",
    "interval": "once",
    "signal": 8,
    "tooltip": false
}
```

Restart Waybar after changing that file.

**3. Bind fuzzel** in `~/.config/niri/config.kdl` (this path is enabled):

```kdl
Mod+Shift+A hotkey-overlay-title="Pick Waybar hint: fuzzel" {
    spawn "$BARINFOO/bin/pick-hint.sh";
}
```

niri reloads its config on save. Press `Mod+Shift+A`, type to filter `hints.json`, and press Enter to update the bar.

**4. Optional: focused-window updates** (written, not enabled). Copy the commented lines from `contrib/niri.kdl`, put your real `$BARINFOO` path in them, then uncomment:

- `spawn-at-startup "$BARINFOO/bin/poll-niri.sh"` — ask niri every 30 seconds
- `Mod+Shift+W` — ask niri once, immediately

If both this poll and fuzzel are on, the poll overwrites a fuzzel pick on its next tick.

Ready-to-copy binds are in `contrib/niri.kdl`. Keep those paths in sync with this repository.

## Contributing

### Development

Scripts live in `bin/`. Shared paths and the Waybar signal helper are in `bin/common.sh`. Waybar reads `bin/waybar-hint.sh`; fuzzel writes through `bin/pick-hint.sh`; niri updates go through `bin/sync-from-niri.sh` and `bin/poll-niri.sh`.

After changing `hints.json` or a script, run the script you touched from a terminal before opening a pull request. To refresh the bar without fuzzel, send `SIGRTMIN+8` to Waybar (`pkill -RTMIN+8 waybar`).

### AI Usage

AI-written code is allowed. A human must review all of it before it is merged.

All prose must be written by a human. That includes user-facing strings in the repo, issue text, and pull request titles and bodies. Do not paste model output into those places.

Each pull request must name the AI tools and models used.

## License

This project is licensed under the **GNU General Public License v3.0** (GPLv3).

See the [LICENSE](LICENSE) file for the full text.

```
Copyright (C) 2026 NailFec

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```

