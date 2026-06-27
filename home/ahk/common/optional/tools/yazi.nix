{ pkgs, lib, ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y"; # Fix warning

    # Fetch the plugin from GitHub
    # plugins = {
    #   compress = pkgs.fetchFromGitHub {
    #     owner = "KKV9";
    #     repo = "compress.yazi";
    #     rev = "main";
    #     sha256 = "sha256-Mby185FCJY6nqHcHDQu+D5SLk+wGcyeUHK8yAvrd4TM=";
    #   };
    # };

    # Bind a key (e.g., 'c') to trigger the compression menu
    # keymap = {
    #   manager.prepend_keymap = [
    #     {
    #       on = [ "c" "z"];
    #       run = "plugin compress";
    #       desc = "Archive selected files";
    #     }
    #   ];
    # };
  };
  xdg.desktopEntries = {
    yazi = {
      name = "Yazi";
      genericName = "File Manager";
      exec = "yazi %u";
      terminal = true;
      categories = [ "Utility" "Core" "System" "FileTools" "FileManager" ];
      mimeType = [ "inode/directory" ];
    };
  };
  home.packages = with pkgs; [xdg-terminal-exec xdg-desktop-portal-termfilechooser];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
    ];
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -e
      multiple="$1"
      directory="$2"
      save="$3"
      path="$4"
      out="$5"

      if [ -z "$path" ]; then
        path="."
      fi

      if [ "$save" = "1" ]; then
        exec ${pkgs.ghostty}/bin/ghostty --title=termfilechooser -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
      elif [ "$directory" = "1" ]; then
        exec ${pkgs.ghostty}/bin/ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" --cwd-file="$out.1" "$path"
      elif [ "$multiple" = "1" ]; then
        exec ${pkgs.ghostty}/bin/ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
      else
        exec ${pkgs.ghostty}/bin/ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
      fi
    '';
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=/home/ahk/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
  '';

  xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce ["termfilechooser"];
  xdg.portal.config.common.default = [ "termfilechooser" ];
}
