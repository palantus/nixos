{ pkgs, ... }:
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
}
