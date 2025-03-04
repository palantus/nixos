{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Development
      # tokei

      # Device imaging
      # rpi-imager

      # Productivity
      # drawio
      grimblast
      libreoffice

      # Privacy
      #veracrypt
      #keepassxc

      # Web sites
      # zola

      # Media production
      # audacity
      # blender-hip # -hip variant includes h/w accelrated rendering with AMD RNDA gpus
      gimp
      inkscape
      obs-studio

      # VM and RDP
      remmina
      freerdp
      ;
  };
  #Disabled for now. grimblast
  #  services.flameshot = {
  #      enable = true;
  #     package = flameshotGrim;
  #  };
}
