
{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "bash";
      TERM = "ghostty";
      TERMINAL = "ghostty";
      VISUAL = "nano";
      EDITOR = "nano";
      MANPAGER = "man"; # see ./cli/bat.nix
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

  };
  #TODO(xdg): maybe move this to its own xdg.nix?
  # xdg packages are pulled in below
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/.desktop";
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/audio";
      pictures = "${config.home.homeDirectory}/media/images";
      videos = "${config.home.homeDirectory}/media/video";
      # publicshare = "/var/empty"; #using this option with null or "/var/empty" barfs so it is set properly in extraConfig below
      # templates = "/var/empty"; #using this option with null or "/var/empty" barfs so it is set properly in extraConfig below

      extraConfig = {
        # publicshare and templates defined as null here instead of as options because
        XDG_PUBLICSHARE_DIR = "/var/empty";
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };
  };

  home.packages = builtins.attrValues {
      inherit (pkgs)

        # Packages that don't have custom configs go here
        btop # resource monitor
        copyq # clipboard manager
        # coreutils # basic gnu utils
        curl
        eza # ls replacement
        # dust # disk usage
        # fd # tree style ls
        # findutils # find
        # fzf # fuzzy search
        jq # json pretty printer and manipulator
        nix-tree # nix package tree viewer
        # neofetch # fancier system info than pfetch
        # ncdu # TUI disk usage
        # pciutils
        # pfetch # system info
        # pre-commit # git hooks
        # p7zip # compression & encryption
        ripgrep # better grep
        # steam-run # for running non-NixOS-packaged binaries on Nix
        usbutils
        # tree # cli dir tree viewer
        unzip # zip extraction
        # unrar # rar extraction
        # wev # show wayland events. also handy for detecting keypress codes
        # wget # downloader
        # xdg-utils # provide cli tools such as `xdg-mime` and `xdg-open`
        # xdg-user-dirs
        # yq-go # yaml pretty printer and manipulator
        # zip # zip compression
        ;
    };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
