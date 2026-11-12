# Repository Guide for Agents

## Purpose and conventions

This repository is Anders's personal NixOS desktop-and-laptop configuration, implemented as a Nix flake. Keep changes small and host-aware: a shared module can affect several machines. Do not run a system switch or otherwise deploy a configuration unless explicitly requested.

## Repository map

- `flake.nix`, `flake.lock` — flake inputs and generated NixOS configurations. Inputs include nixpkgs (`nixos-unstable`), Home Manager, Stylix, NVF, Noctalia, and workmux.
- `hosts/nixos/<host>/` — one NixOS module per host, including host-specific `hardware-configuration.nix` files.
- `hosts/common/core/` — shared system setup, host identity, primary-user integration, and common defaults.
- `hosts/common/optional/` — reusable system-level feature modules, enabled explicitly by each host.
- `hosts/common/users/` — shared system account definitions.
- `home/<user>/<host>.nix` — Home Manager entry point for a user on a particular host.
- `home/<user>/common/` — reusable user-level core and optional program/desktop configurations.
- `modules/common/`, `modules/home/` — reusable NixOS/Home Manager options and modules, including `hostSpec` and monitor settings.
- `lib/default.nix` — custom helpers such as `lib.custom.relativeToRoot` and `lib.custom.scanPaths`.
- `assets/` — wallpapers and other local visual assets.
- `rebuild.sh` — wrapper for `nixos-rebuild switch`; it removes `~/.config/mimeapps.list.bk` before and after rebuilding.

## How configurations are assembled

`flake.nix` discovers host names from directories directly under `hosts/nixos/` and creates `nixosConfigurations.<host>` using `hosts/nixos/<host>/`. A host module typically imports its hardware file, Home Manager, Stylix, `hosts/common/core`, and a list of selected `hosts/common/optional/*.nix` modules.

The shared primary-user module uses `hostSpec.username` and `hostSpec.hostName` to select `home/<username>/<hostName>.nix`. That host-specific Home Manager file then imports the user's shared core and selected optional groups. Inspect this import chain before changing a shared module or moving a file.

Some `default.nix` files use `lib.custom.scanPaths`, which automatically includes sibling Nix files and directories. Check whether a directory is scanned before adding a module: a new file may become active without an explicit import being added nearby. System optional modules, by contrast, are generally selected in each host's import list.

Current host directories are `desktop`, `hplap`, `thinkpad`, and `worklap`. User Home Manager trees include `ahk`, `anna`, and `simon`. The main desktop and laptop entries for `ahk` are under `home/ahk/`.

## Making and validating changes

- Preserve each host's `system.stateVersion`; do not change it as part of routine package or input updates.
- Prefer a host-specific module when a setting belongs to one machine; use shared modules only for behavior intended across hosts.
- Keep hardware settings in the corresponding host directory. Do not copy one machine's hardware configuration to another.
- Keep credentials and private values out of tracked Nix files, documentation, logs, and commits. The shared host core references `inputs.nix-secrets`; however, the checked-in `flake.nix` and the root input list in `flake.lock` do not currently declare that input. Treat this as an existing evaluation prerequisite/gap: do not invent secret values or silently remove the reference; confirm the intended setup with the owner.
- For a Nix-enabled environment, start with `nix flake show` and evaluate the affected output, e.g. `nix eval .#nixosConfigurations.desktop.config.system.build.toplevel.drvPath`. Build with `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --no-link` when appropriate. A successful evaluation/build is not permission to activate it.
- `rebuild.sh <host>` and `sudo nixos-rebuild switch --flake <repo>#<host>` activate a system configuration; do not run these in agent work unless deployment is explicitly requested.
- Review `git diff --check`, `git diff`, and the final Git status before committing.

## Pull requests

Use a focused branch and commit for each change. Describe the affected host(s), the validation actually performed, and any evaluation blockers in the pull request. Do not claim a Nix evaluation/build passed unless it was run successfully.
