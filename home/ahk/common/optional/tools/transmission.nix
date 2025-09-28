
{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      transmission_4-gtk
      ;
  };
}
