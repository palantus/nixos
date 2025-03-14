# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

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
        # "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
        "hosts/common/optional/de.nix" # desktop environment (gdm + x server)
        "hosts/common/optional/gnome.nix" # window manager
        "hosts/common/optional/hyprland.nix" # window manager
        # "hosts/common/optional/neovim.nix" # neovim nvf
        # "hosts/common/optional/msmtp.nix" # for sending email notifications
        # "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
        # "hosts/common/optional/obsidian.nix" # wiki
        # "hosts/common/optional/plymouth.nix" # fancy boot screen
        # "hosts/common/optional/protonvpn.nix" # vpn
        # "hosts/common/optional/scanning.nix" # SANE and simple-scan
        # "hosts/common/optional/thunar.nix" # file manager
        "hosts/common/optional/vlc.nix" # media player
        "hosts/common/optional/wireguard.nix" # media player
        "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
        # "hosts/common/optional/yubikey.nix" # yubikey related packages and configs
        # "hosts/common/optional/zsa-keeb.nix" # Moonlander keeb flashing stuff
      ])
    ];
  
  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "thinkpad";
    wifi = lib.mkForce true;
    networkmanager = true;
    wireguardIP = "10.8.0.3/24";
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
