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
        "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
        # "hosts/common/optional/yubikey.nix" # yubikey related packages and configs
        # "hosts/common/optional/zsa-keeb.nix" # Moonlander keeb flashing stuff
      ])
    ];
  
  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "desktop";
  };

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     "root" = import ./home-root.nix;
  #     "ahk" = import ./home-ahk.nix;
  #   };
  # };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

  # networking.hostName = "ahk-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = false;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  # };

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.ahk = {
  #   isNormalUser = true;
  #   description = "Anders Kristiansen";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [
  #   #  thunderbird
  #   ];
  # };

  # Install firefox.
  # programs.firefox.enable = true;
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    # home-manager
    # git
    waybar
    dunst
    ghostty
    rofi-wayland
    # networkmanagerapplet
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
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
  system.stateVersion = "24.11"; # Did you read the comment?

}
