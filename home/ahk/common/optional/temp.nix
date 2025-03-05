{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # neovim
      wget
      ghostty
      lazygit
      unzip
      nodejs
      obsidian
      obs-studio
      ;
  };
}
