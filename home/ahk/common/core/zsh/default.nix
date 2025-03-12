{
  config,
  pkgs,
  lib,
  ...
}:
let
  devDirectory = "~/dev";
  devNix = "${devDirectory}/nix";
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.share = true;

    plugins =
      [
        # {
        #   name = "powerlevel10k-config";
        #   src = ./p10k;
        #   file = "p10k.zsh.theme";
        # }
        # {
        #   name = "zsh-powerlevel10k";
        #   src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        #   file = "powerlevel10k.zsh-theme";
        # }
      ];

    initExtraFirst = ''
    '';

    initExtra = ''
      # autoSuggestions config

      unsetopt correct # autocorrect commands

      setopt hist_ignore_all_dups # remove older duplicate entries from history
      setopt hist_reduce_blanks # remove superfluous blanks from history items
      setopt inc_append_history # save history entries as soon as they are entered

      # auto complete options
      setopt auto_list # automatically list choices on ambiguous completion
      setopt auto_menu # automatically use menu completion
      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*' group-name "" # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

      #      bindkey '^I' forward-word         # tab
      #      bindkey '^[[Z' backward-word      # shift+tab
      #      bindkey '^ ' autosuggest-accept   # ctrl+space
    '';

    shellAliases = {
      # Overrides those provided by OMZ libs, plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #-------------Bat related------------
      cat = "bat --paging=never";
      diff = "batdiff";
      rg = "batgrep";
      man = "batman";

      #------------Navigation------------
      doc = "cd $HOME/documents";
      # scripts = "cd $HOME/scripts";
      # ts = "cd $HOME/.talon/user/fidget";
      # src = "cd $HOME/src";
      # edu = "cd $HOME/src/edu";
      wiki = "cd $HOME/obsidian/Pavault";
      # uc = "cd $HOME/src/unmoved-centre";
      l = "eza -la --color=never";
      la = "eza -la --color=never";
      ll = "eza -l --color=never";
      ls = "eza --color=never";

      #------------Nix src navigation------------
      # cnc = "cd ${devNix}/nix-config";
      # cns = "cd ${devNix}/nix-secrets";
      # cnh = "cd ${devNix}/nixos-hardware";
      # cnp = "cd ${devNix}/nixpkgs";

      #-----------Nix commands----------------
      # nfc = "nix flake check";
      # ne = "nix instantiate --eval";
      # nb = "nix build";
      ns = "nix shell";

      #-------------justfiles---------------
      # jr = "just rebuild";
      # jrt = "just rebuild-trace";
      # jl = "just --list";
      # jc = "$just check";
      # jct = "$just check-trace";

      #-------------Neovim---------------
      # e = "nvim";
      # vi = "nvim";
      # vim = "nvim";

      #-------------SSH---------------
      ssh = "TERM=xterm ssh";

      #-------------Git Goodness-------------
      # just reference `$ alias` and use the defaults, they're good.
    };
  };

  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      # zsh_indicator = "[ZSH](bright-white) ";
      zsh_indicator = "";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };
}
