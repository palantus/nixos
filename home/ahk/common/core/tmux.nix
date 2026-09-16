{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      tmux
      sesh
      fd
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
      # tmux-which-key
      sensible
      catppuccin
      tmux-fzf
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g @catppuccin_flavour 'mocha'
      set -g extended-keys on
      set -g extended-keys-format csi-u

      unbind C-Space
      set-option -g prefix C-Space
      bind-key C-Space send-prefix
      bind-key C-b send-prefix

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
      # Resize panes with leader + arrow keys
      bind Up resize-pane -U 20
      bind Down resize-pane -D 20
      bind Left resize-pane -L 20
      bind Right resize-pane -R 20
      # workmux menu - from: https://github.com/smnatale/dotfiles/blob/main/dot_tmux.conf
      bind w display-menu -x C -y C -T "workmux" \
        "add" a "popup -d '#{pane_current_path}' -w 80% -h 20% -x C -y C -E '~/.config/tmux/workmux-popup.sh add'" \
        "add w/branch" b "popup -d '#{pane_current_path}' -w 80% -h 25% -x C -y C -E '~/.config/tmux/workmux-popup.sh add-from-branch'" \
        "add w/prompt" p "popup -d '#{pane_current_path}' -w 80% -h 20% -x C -y C -E '~/.config/tmux/workmux-popup.sh add-prompt'" \
        "open" o "popup -d '#{pane_current_path}' -w 80% -h 60% -x C -y C -E '~/.config/tmux/workmux-popup.sh open'" \
        "remove" r "popup -d '#{pane_current_path}' -w 80% -h 60% -x C -y C -E '~/.config/tmux/workmux-popup.sh remove'" \
        "close" c "popup -d '#{pane_current_path}' -w 80% -h 60% -x C -y C -E '~/.config/tmux/workmux-popup.sh close'" \
        "dashboard" d "popup -d '#{pane_current_path}' -w 90% -h 90% -x C -y C -E 'workmux dashboard'" \
        "sidebar" s "run-shell 'workmux sidebar'" \
        "quit" q ""
      bind a popup -d '#{pane_current_path}' -w 80% -h 80% -E 'ahkdev'
      set -g allow-rename off
      set -g allow-set-title off
      bind c new-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind % split-window -v -c "#{pane_current_path}"
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
      set -g detach-on-destroy off  # don't exit from tmux when closing a session
      bind -N "last-session (via sesh) " L run-shell "sesh last"
      bind-key "t" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""
    '';
  };
}
