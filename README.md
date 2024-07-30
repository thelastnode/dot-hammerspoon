# .hammerspoon

These are my configuration files for [Hammerspoon](https://www.hammerspoon.org/).

## Install

1. Install Hammerspoon.
2. `git clone https://github.com/thelastnode/dot-hammerspoon ~/.hammerspoon
3. Restart Hammerspoon.

## Features

### [Launch mode](./launch.lua)
Launch mode lets you quickly get to an app by hitting a key chord (<kbd>ctrl</kbd> + <kbd>⌘</kbd> + <kbd>a</kbd>). For example, <kbd>ctrl</kbd> + <kbd>⌘</kbd> + <kbd>a</kbd> followed by `v` will open Visual Studio Code.

#### Special handling for the browser

Google Chrome / Island has [some special handling](./chrome.lua) for multiple profiles. `1` will switch to Island browser (Work profile) and `2` will switch to the personal Chrome window.

You can also configure shortcuts to get to pinned tabs in different profiles.

#### Special handling for Figma
[Figma](./figma.lua) desktop has a feature to open a file URL from the clipboard - this is bound to <kbd>ctrl</kbd> + <kbd>⌘</kbd> + <kbd>a</kbd> followed by <kbd>shift</kbd> + <kbd>f</kbd>.

### [Window Management](./window.lua)
This module lets you snap windows using your keyboard with vim-style directions (hjkl).

Start with <kbd>ctrl</kbd> + <kbd>⌘</kbd> + <kbd>2</kbd> to enable window mode, then any of the following:
- <kbd>space</kbd>: snap to fill the screen
- <kbd>hjkl</kbd>: snap to the left, down, up, or right half of the screen
- <kbd>uom.</kbd>: snap to the the corners of the screen
- <kbd>⌘</kbd> + <kbd>hl</kbd>: snap to left or right 70% of the screen
- <kbd>ctrl</kbd> + <kbd>hjkl</kbd>: move to the left, down, up, or right screen (does not exit window mode, so can be followed by one of the above snapping commands)

### [Time tracker](./timetracker/timetracker.lua)
This module captures which window is active to a SQLite database located at `~/.hammerspoon/data/timetracker.sqlite3`. It has special handling for Google Chrome to capture URLs.

It also includes a [datasette metadata file](./timetracker/datasette-metadata.yml) to see usage in [Datasette](https://datasette.io/). This can be run with:

```sh
datasette ~/.hammerspoon/data/timetracker.sqlite3 --metadata ~/.hammerspoon/timetracker/datasette-metadata.yml
```

After Datasette is running, you can see usage for the day by opening [this link](http://localhost:8001/timetracker/time_usage?_hide_sql=1) (by default).

### [Camera light](./cameralight.lua)
This automation turns on an Elgato key light via [Home Assistant](https://www.home-assistant.io/) when a camera is detected via USB. This requires a Home Assistant token in `~/.hammerspoon/homeassistant`. If the token is missing, the automation will not register.

### [Screen recording mode](./screenrecording.lua)
The `ScreenRecordingMode` function is a convenience utility to center a window on screen and resize it to 1080p. To use it, run `ScreenRecordingMode()` in the Hammerspoon console, then click a window to center it on screen, resize it to 1080p, and open [CleanShot X](https://cleanshot.com/)'s all-in-one capture mode.

You can also pass in a custom width and height for the window, e.g.: `ScreenRecordingMode{ w = 800, h = 600 }`.
