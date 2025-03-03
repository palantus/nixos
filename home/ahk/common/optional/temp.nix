{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      neovim
      wget
      ghostty
      lazygit
      zig
      unzip
      nodejs
      obsidian
      obs-studio
      rustc #Neovim
      cargo #Neovim
      fzf #Neovim
      ripgrep #Neovim
      wl-clipboard # move to core
      hyprlock
      ;
  };
}
