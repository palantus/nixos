# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager

    (map lib.custom.relativeToRoot [
      "modules/common"
      # "modules/hosts/common"
      # "modules/hosts/${platform}"
      # "hosts/common/core/${platform}.nix"
      # "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      # "hosts/common/core/ssh.nix"
      "hosts/common/users/primary"
      # "hosts/common/users/primary/${platform}.nix"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    username = "ahk";
    handle = "palantus";
    inherit (inputs.nix-secrets)
      domain
      email
      userFullName
      networking
      ;
  };

  networking.networkmanager.enable = config.hostSpec.networkmanager;
  networking.hostName = config.hostSpec.hostName;

  # The following would require a setup like:
  # networking.wireless = {
  #   enable = true;
  #   networks."mySSID".psk = "myPSK";
  #   extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
  # };

  # networking.wireless.enable = config.hostSpec.wifi;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.userControlled.enable = config.hostSpec.wifi;

  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://helix.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # System-wide packages, in case we log in as root
  environment.systemPackages = with pkgs;[ 
    openssh 
    usbutils
    udiskie
    udisks
    wget
    unzip
    killall
   # neovim
  ];
  
  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };
  
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-emoji
    proggyfonts
  ];

  stylix = {
    enable = true;
    image = (lib.custom.relativeToRoot "assets/wallpapers/zen-01.png");
    #      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    #      cursor = {
    #        package = pkgs.foo;
    #        name = "";
    #      };
    #     fonts = {
    #monospace = {
    #    package = pkgs.foo;
    #    name = "";
    #};
    #sanSerif = {
    #    package = pkgs.foo;
    #    name = "";
    #};
    #serif = {
    #    package = pkgs.foo;
    #    name = "";
    #};
    #    sizes = {
    #        applications = 12;
    #        terminal = 12;
    #        desktop = 12;
    #        popups = 10;
    #    };
    #};
    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 0.8;
    };
    polarity = "dark";
    # program specific exclusions
    #targets.foo.enable = false;
  };

  # Usb disks and mounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Force home-manager to use global packages
  # home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
}
