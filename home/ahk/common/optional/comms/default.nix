{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = with pkgs; [

    # Electron overrides for better wayland/scaling support:
    (discord.override {
      withOpenASAR = true; # Keeps the wrapper clean and snappy
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    })
    (teams-for-linux.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/teams-for-linux \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"
      '';
    }))

    # Other:

    # signal-desktop
    # telegram-desktop
    # slack
    obs-studio
  ];
}
