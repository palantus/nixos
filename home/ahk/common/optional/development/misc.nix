{ pkgs, config, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # neovim
      lazygit
      nodejs
      ;
  };

  # Use a user-writable directory for global installs
  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-packages
  '';

  # Ensure the directory exists
  home.activation = {
    createNpmFolder = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.npm-packages/bin
    '';
  };
}
