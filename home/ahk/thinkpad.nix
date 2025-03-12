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
    common/optional/terminals
    # common/optional/helper-scripts
    # common/optional/gaming
    # common/optional/media
    common/optional/tools
    #
    # common/optional/atuin.nix
    common/optional/xdg.nix # file associations
    # common/optional/sops.nix
  ];
  
  # Desktop settings

  home.packages = builtins.attrValues {
    inherit (pkgs)
      networkmanagerapplet
      ;
  };

  wayland.windowManager.hyprland.settings.exec-once = with pkgs; [
        ''${waypaper}/bin/waypaper --restore''
        ''${networkmanagerapplet}/bin/nm-applet --indicator''

        ''[workspace 1 silent]${firefox}/bin/firefox''
  ];
  wayland.windowManager.hyprland.settings.input.kb_layout = "dk-latin1";


  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/

  monitors = [
    {
      name = "LVDS-1";
      width = 1600;
      height = 900;
      refreshRate = 60;
      x = 0;
      y = 0;
      # vrr = 1;
      primary = true;
      workspace = "1";
      workspaces = ["2" "3" "4" "5" "6"]; 
    }
  ];
}
