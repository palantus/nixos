{
  inputs,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  imports = [
    ./scripts.nix
  ];
  home = {
    packages = with pkgs; [
      niri
      # xwayland-satellite # xwayland support
      inputs.xwayland-satellite.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    file =
      let
        hostPath = "hosts/nixos/${osConfig.hostSpec.hostName}/niri";
        finalConfig =
          lib.flatten [
            # order matters
            ./inputs.kdl
            (map lib.custom.relativeToRoot [
              "${hostPath}/outputs.kdl"
              "${hostPath}/workspaces.kdl"
              "${hostPath}/startup.kdl"
            ])
            ./binds.kdl
            ./rules.kdl
            ./config.kdl
          ]
          |> lib.concatMapStringsSep "\n" lib.readFile;
      in
      {
        ".config/niri/config.kdl".text = finalConfig;
        ".config/niri/animations/" = {
          source = ./animations;
          recursive = true;
        };
      };
  };
}
