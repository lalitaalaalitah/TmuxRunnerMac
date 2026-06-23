# TmuxRunner for macOS

A lightweight macOS application wrapper that sets `tmux` as the default application for running `.sh` and `.command` scripts. When you double-click a script in Finder, it will open your terminal (Alacritty by default), attach to a `tmux` session, and run your script inside a new tmux window.

## How It Works

1. Double-clicking a script sends the file path to `TmuxRunner.app`.
2. The AppleScript logic finds the script's directory.
3. It opens Alacritty and executes a `tmux` command to either create a new window in an existing session or start a new detached session.
4. The `remain-on-exit on` tmux option prevents the pane from closing immediately when the script finishes.

## Installation

### Declarative Installation from Release (Recommended)

You can download the pre-compiled `TmuxRunner.zip` from GitHub Releases, extract it, and map it to your applications folder using Home Manager:

```nix
{ config, pkgs, lib, ... }:

let
  version = "1.0.0"; # Update this to the latest release version
  
  # Fetch the compiled app bundle from GitHub Releases
  tmuxRunnerZip = pkgs.fetchurl {
    url = "https://github.com/lalitaalaalitah/TmuxRunnerMac/releases/download/v${version}/TmuxRunner.zip";
    sha256 = "0000000000000000000000000000000000000000000000000000"; # Replace with actual sha256 or run nix-prefetch-url
  };

  # Create a derivation to unzip the app
  tmuxRunnerApp = pkgs.stdenv.mkDerivation {
    pname = "TmuxRunner";
    inherit version;
    src = tmuxRunnerZip;
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/Applications
      cp -r TmuxRunner.app $out/Applications/
    '';
  };
in
{
  # 1. Install duti and the TmuxRunner application
  home.packages = [ pkgs.duti tmuxRunnerApp ];
  
  # 2. Set default file associations
  home.activation.setTmuxRunnerDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Register the app with Launch Services so macOS knows about it
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "${tmuxRunnerApp}/Applications/TmuxRunner.app"
    
    # Associate .sh and .command files with TmuxRunner
    $DRY_RUN_CMD ${pkgs.duti}/bin/duti -s com.user.TmuxRunner public.shell-script all
    $DRY_RUN_CMD ${pkgs.duti}/bin/duti -s com.user.TmuxRunner com.apple.terminal.shell-script all
  '';
}
```

### Declarative Installation from Source Repo

If you prefer to pull the pre-compiled app directly from the source repository instead of the release artifact:

```nix
{ config, pkgs, lib, ... }:

let
  # Fetch the repository
  tmuxRunnerRepo = builtins.fetchGit {
    url = "https://github.com/lalitaalaalitah/TmuxRunnerMac.git";
    ref = "main";
    # Uncomment and use a specific revision for reproducibility:
    # rev = "your_commit_hash_here";
  };
in
{
  # 1. Install duti
  home.packages = [ pkgs.duti ];
  
  # 2. Map TmuxRunner.app to your Applications folder
  home.file."Applications/TmuxRunner.app" = {
    source = "${tmuxRunnerRepo}/TmuxRunner.app";
    recursive = true;
  };
  
  # 3. Set default file associations
  home.activation.setTmuxRunnerDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Register the app with Launch Services so macOS knows about it
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "$HOME/Applications/TmuxRunner.app"
    
    # Associate .sh and .command files with TmuxRunner
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
