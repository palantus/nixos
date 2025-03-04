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

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = with pkgs;[ 
    openssh 
    usbutils
    udiskie
    udisks
    wget
    # neovim
  ];

  # Usb disks and mounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Force home-manager to use global packages
  # home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;
}
