# bag

The hobos shell environment.

## Requirements

- nix-shell
- Makefile (for the single `make` start)

## Start

`make`

## Configuration

- Defaults are in `.env.default`
- User can create `.env` to overwrite options
- The variable `$BAG_DIR` is the root path of bag

### Settings

#### `BAG_HOME_DIR`

Default: `$HOME`

#### `BAG_CONFIG_DIR`

Default: `$HOME/.config`

#### `BAG_CONFIG_MODE`

Default: `abort`

##### `abort`

If Bag encounters config files that already exist, it will abort.

##### `keep`

Existing config files will be kept, any other used by Bag will be created.

##### `overwrite`

All config files will be created, overwritten if they already exist.

##### `overwrite-restore`

A backup of existing config files will be created, and restored when you quit Bag.

##### `overwrite-backup`

A timestamped backup of existing config files will be created, if it differs from the newconfig file.

#### `BAG_ZELLIJ_SESSION_NAME`

Default: `bag`

#### `BAG_SHELL`

Default: `fish`

#### `BAG_EDITOR`

Default: `micro`

## In the bag

### nix-shell

### Busybox

### Zellij

#### Keybindings

- Remapped mode keybindings to function keys, so the do not clash with other applications
- Alt , = Focus Pane Up
- Alt . = Focuse Pane Down
- Removed tmux keybinding (Ctrl b)
- Added Alt x to close focused pane
- Added Alt e to open a new pane, select file with broot and open in micro
- Added Alt s to open a new pane, search DuckDuckgo with ddgr and open in lynx
- Added Alt m to open a new pane, add a note to current notebook with nb
- Added Alt t to open a new tab
- Added Alt 1 to go to first tab
- Added Alt 2 to go to second tab, Alt 3 ...
- Added F11 to detach the session

#### Layout

- Footer with infos via the `infobar` command
- Search Tab
- Edit Tab
- Notes Tab

### Fish

- Disabled greeting message

#### Functions

##### `infobar`

Show following information periodically (1s) in one line:

- username
- hostname
- external ip
- memory usage
- disk usage
- cpy usage
- date
- time

##### `broot-micro`

Select a file and pass it to micro.

##### `note`

A slim wrapper for `nb add`, no argument will prompt for the note title, or pass as first argument.

##### `ddg`

Open `lite.duckduckgo.com` in Lynx.

### Broot

- Output the file path to open with echo when hitting enter

### Micro

### Nb

## Development

`make dev`: Creates a `.env` file, which sets the home directory to `./home` and the config directory to `./home/.config`
