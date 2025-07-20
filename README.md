# sa-menu.nvim

A Neovim plugin that plays sound effects when switching between modes and buffers, bringing audio feedback to your editing experience.

## Features

- Plays distinct sounds when switching between:
  - Normal mode
  - Insert mode
  - Visual mode (all variants)
  - Command mode
  - Buffer switching
- Smart sound queueing to prevent audio overlap
- Debouncing to avoid excessive sound playback
- Cross-platform support (macOS, Linux)

## Requirements

- Neovim >= 0.5.0
- Audio player:
  - **macOS**: `afplay` (built-in)
  - **Linux**: One of the following:
    - `aplay` (ALSA)
    - `paplay` (PulseAudio)
    - `play` (SoX)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "nandoolle/sa-menu.nvim",
  config = function()
    require("sa-menu").setup()
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "nandoolle/sa-menu.nvim",
  config = function()
    require("sa-menu").setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nandoolle/sa-menu.nvim'
```

Then add to your init.lua:

```lua
require("sa-menu").setup()
```

## Configuration

You can customize the plugin behavior by passing options to the setup function:

```lua
require("sa-menu").setup({
  -- Minimum time between sounds in milliseconds (default: 150)
  debounce_time = 150,
  
  -- Enable/disable the plugin (default: true)
  enabled = true,
})
```

## Sound Files

The plugin includes the following sound effects in the `samps/` directory:

- `normal.wav` - Played when entering normal mode
- `insert.wav` - Played when entering insert mode
- `visual.wav` - Played when entering visual mode
- `command.wav` - Played when entering command mode
- `switch-buffer.wav` - Played when switching buffers

## Customizing Sounds

You can replace any of the `.wav` files in the `samps/` directory with your own sounds. Just make sure to keep the same filenames.

## Troubleshooting

### No sound on Linux

Make sure you have one of the supported audio players installed:

```bash
# For ALSA
sudo apt-get install alsa-utils

# For PulseAudio
sudo apt-get install pulseaudio-utils

# For SoX
sudo apt-get install sox
```

### Sounds are playing too frequently

Increase the `debounce_time` in the setup configuration:

```lua
require("sa-menu").setup({
  debounce_time = 300  -- Wait 300ms between sounds
})
```

## License

MIT License - See LICENSE file for details

