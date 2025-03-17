{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      tmux
      ;
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    resizeAmount = 10;
    # sensibleOnTop = true;
    # prefix = "C-b";
    

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
      #tmux-which-key
      sensible
      catppuccin
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g @catppuccin_flavour 'mocha'
      bind S command-prompt -p "New Session:" "new-session -A -s '%%'"
      bind K confirm kill-session
      set-option -g status-position top
      set-window-option -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|\\.?n?vim?x?(-wrapped)?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
