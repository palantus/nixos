{
  pkgs,
  lib,
  # config,
  ...
}:
# let
#   inherit (config.lib.formats.rasi) mkLiteral;
# in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = lib.mkForce "fancy";
    # theme = lib.mkForce{
    #   "*" = {
    #     background-color = mkLiteral "#000000";
    #     foreground-color = mkLiteral "rgba(250, 251, 252, 100%)";
    #     border-color = mkLiteral "#FFFFFF";
    #     width = 512;
    #   };
    #   "#inputbar" = {
    #     children = map mkLiteral [ "prompt" "entry" ];
    #   };
    #   "#textbox-prompt-colon" = {
    #     expand = false;
    #     str = ":";
    #     margin = mkLiteral "0px 0.3em 0em 0em";
    #     text-color = mkLiteral "@foreground-color";
    #   };
    # };
    # theme = builtins.toFile "theme.rasi" ''
    #   @import "../path/to/style-1.rasi"
    # '';
    # theme = lib.mkForce (lib.custom.relativeToRoot "assets/rofi-style1.rasi");
    terminal = "ghostty";

    extraConfig = {
      show-icons = true;
      # icon-theme = "";
      # hover-select = true;
      drun-match-fields = "name";
      drun-display-format = "{name}";
      #FIXME not working
      drun-search-paths = "/home/ahk/.nix-profile/share/applications,/home/ahk/.nix-profile/share/wayland-sessions";

    };
  };
}
