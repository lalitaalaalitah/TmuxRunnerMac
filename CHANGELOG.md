# Changelog

## [v1.2.1] - 2026-06-24
### Fixed
- Fixed an issue where `tmux: command not found` error occurred when opening scripts that contained `tmux` commands. `TmuxRunnerMac` now explicitly exports common `PATH` directories (such as Nix and Homebrew locations) before executing the user's script so that `tmux` is correctly found in the environment.

## [v1.2] - 2026-06-24
### Fixed
- Fixed an issue where dropping a script that already manages its own tmux session would wrap it in a nested tmux session, potentially causing errors. `TmuxRunnerMac` now scans the target script and avoids nesting tmux if the script already contains a `tmux` command.

## [v1.1] - 2026-06-23
### Added
- Feature to keep the terminal pane open by pausing the script before exit to let the user read the output.
- Bumped version to 1.1.

## [v1.0.0] - 2026-06-23
### Added
- Initial release of TmuxRunner.
- Added version and publisher info to the application (`Info.plist`).
- GitHub Actions workflow for automatic releases.
