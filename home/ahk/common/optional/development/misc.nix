{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      lazygit
      nodejs
      ;
  };
}
