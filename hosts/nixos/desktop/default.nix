# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, ... }:

{
  imports = lib.flatten [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.stylix.nixosModules.stylix

      (map lib.custom.relativeToRoot [
        "hosts/common/core"

        #
        # ========== Optional Configs ==========
        #
        # "hosts/common/optional/services/greetd.nix" # display manager
        # "hosts/common/optional/services/openssh.nix" # allow remote SSH access
        # "hosts/common/optional/services/printing.nix" # CUPS
        # "hosts/common/optional/audio.nix" # pipewire and cli controls
        "hosts/common/optional/libvirt.nix" # vm tools
        "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
        "hosts/common/optional/de.nix" # desktop environment (gdm + x server)
        "hosts/common/optional/gnome.nix" # window manager
        "hosts/common/optional/hyprland.nix" # window manager
        # "hosts/common/optional/msmtp.nix" # for sending email notifications
        # "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
        # "hosts/common/optional/obsidian.nix" # wiki
        # "hosts/common/optional/plymouth.nix" # fancy boot screen
        # "hosts/common/optional/protonvpn.nix" # vpn
        # "hosts/common/optional/scanning.nix" # SANE and simple-scan
        # "hosts/common/optional/thunar.nix" # file manager
        "hosts/common/optional/vlc.nix" # media player
        "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
        "hosts/common/optional/gnupg.nix" # wayland components and pkgs not available in home-manager
        # "hosts/common/optional/yubikey.nix" # yubikey related packages and configs
        # "hosts/common/optional/zsa-keeb.nix" # Moonlander keeb flashing stuff
      ])
    ];
  
  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "desktop";
    networkmanager = false;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Needed for OBS studio virtual camera:
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

  # Fix for random network adapter pcie disconnects:
  boot.kernelParams = [ "pcie_port_pm=off" "pcie_aspm.policy=performance" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
