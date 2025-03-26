{
  pkgs,
  lib,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = lib.mkForce "fancy";
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
