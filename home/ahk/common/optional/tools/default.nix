{ pkgs, ... }:
{
  imports = [ 
    ./transmission.nix 
  ];

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
      # tmux

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

      # VM and RDP
      remmina
      freerdp

      obsidian
      ;
  };

  services.flameshot = {
    enable = true;
  };
}
