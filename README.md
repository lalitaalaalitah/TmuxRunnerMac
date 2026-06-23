# TmuxRunner for macOS

A lightweight macOS application wrapper that sets `tmux` as the default application for running `.sh` and `.command` scripts. When you double-click a script in Finder, it will open your terminal (Alacritty by default), attach to a `tmux` session, and run your script inside a new tmux window.

## How It Works

1. Double-clicking a script sends the file path to `TmuxRunner.app`.
2. The AppleScript logic finds the script's directory.
3. It opens Alacritty and executes a `tmux` command to either create a new window in an existing session or start a new detached session.
4. The `remain-on-exit on` tmux option prevents the pane from closing immediately when the script finishes.

## Installation

### Declarative Installation (Nix / Home Manager)

Since `TmuxRunner.app` is pre-compiled in this repository, you can simply pull this repo into your Nix configuration and map the `TmuxRunner.app` to your `~/Applications/Home Manager Apps/` directory, and configure `duti` declaratively via Home Manager:

```nix
{
  # In your home.packages or similar:
  home.packages = [ pkgs.duti ];
  
  # ... Add derivation or file sourcing for TmuxRunner.app here ...
  
  # Set default associations
  home.activation.setTmuxRunnerDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "$HOME/Applications/TmuxRunner.app"
    $DRY_RUN_CMD ${pkgs.duti}/bin/duti -s com.user.TmuxRunner public.shell-script all
    $DRY_RUN_CMD ${pkgs.duti}/bin/duti -s com.user.TmuxRunner com.apple.terminal.shell-script all
  '';
}
```

### Manual Installation

If you want to install and register it manually, run the included `install.sh` script:

```bash
chmod +x install.sh
./install.sh
```

## Building from Source

If you want to modify the AppleScript (e.g. to change the terminal emulator from Alacritty to Ghostty), you can rebuild the `.app` bundle:

1. Edit `src/main.applescript`.
2. Run the build script:

```bash
chmod +x build.sh
./build.sh
```

### The `duti` commands

For reference, the specific `duti` commands used to associate the file extensions with this application's bundle identifier (`com.user.TmuxRunner`) are:

```bash
duti -s com.user.TmuxRunner public.shell-script all
duti -s com.user.TmuxRunner com.apple.terminal.shell-script all
```
