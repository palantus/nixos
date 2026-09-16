{
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      zoxide
      ;
  };

  programs.zoxide.enable = true;
}
