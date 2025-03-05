{ pkgs, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers
    common/optional/desktops # default is hyprland
    common/optional/development
    common/optional/comms
    # common/optional/helper-scripts
    # common/optional/gaming
    # common/optional/media
    common/optional/tools
    #
    # common/optional/atuin.nix
    common/optional/xdg.nix # file associations
    common/optional/temp.nix # TODO: move
    # common/optional/sops.nix
  ];

  wayland.windowManager.hyprland.settings.exec-once = with pkgs; [
        ''${waypaper}/bin/waypaper --restore''

        ''[workspace 1 silent]${firefox}/bin/firefox''
        ''[workspace 1 silent]${obsidian}/bin/obsidian''
  ];

  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/

  monitors = [
    {
      name = "DP-2";
      width = 3440;
      height = 1440;
      refreshRate = 100;
      x = 0;
      y = 0;
      # vrr = 1;
      primary = true;
      workspace = "1";
      workspaces = ["2" "3" "4" "5"]; 
    }
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      x = 3440;
      y = 0;
      workspace = "6";
      scale = 1.5;
    }
  ];
}
