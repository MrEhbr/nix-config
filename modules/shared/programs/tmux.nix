{ pkgs, lib, config, ... }:
{

  programs.tmux = {
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tmux-fzf
      yank
    ];

    terminal = "${pkgs.fish}/bin/fish";
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    customPaneNavigationAndResize = true;
    mouse = true;
    historyLimit = 50000;

    extraConfig = ''
      #-----------------------------------------------------------
      # Terminal & Color Settings
      #-----------------------------------------------------------
      set -ga terminal-overrides ",*256col*:Tc"
      # Enable undercurl (both basic and with color support)
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set-option -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set -as terminal-features ",*:RGB"
      # Use the current TERM, or consider "tmux-256color" if preferred
      set -g default-terminal "xterm-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g xterm-keys on

      #-----------------------------------------------------------
      # Basic Options & Pane Settings
      #-----------------------------------------------------------
      setw -g mode-keys vi
      set -g history-limit 50000
      set -g base-index 1
      setw -g pane-base-index 1
      set -g allow-rename on
      set -g renumber-windows on
      set -g set-titles on
      setw -g aggressive-resize on
      set -g detach-on-destroy off
      set -g bell-action any
      set -g visual-bell off
      set -g visual-activity off
      set -g focus-events on
      set -s escape-time 0
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      #-----------------------------------------------------------
      # Appearance & Status Bar Settings
      #-----------------------------------------------------------
      set -g message-style 'bg=default,fg=yellow,bold'
      set -g status-style  'bg=default'
      set -g status-interval 4
      set -g status-position bottom
      set -g status-justify left

      # Status Left: Session name with a colored segment when in prefix mode
      set -g status-left '#{?client_prefix,#[fg=#d65c0d]#[bg=#d65c0d],#[fg=default] }#[fg=brightwhite,bold]#S#[fg=none]'
      set -ga status-left '#[bg=default]#{?client_prefix,#[fg=#d65c0d] ,#[fg=default]  }'
      set -g status-left-length 80

      # Status Right: Path, git branch (if available) and time
      set -g status-right "#[bg=default,fg=brightblue] #{pane_current_path} #[bg=default,fg=gray]|"
      set -ga status-right "#[fg=gray,bold]#{?pane_mode,#[fg=default] #{pane_mode} #[bg=default]#[fg=gray]|,}"
      set -ga status-right "#(cd #{pane_current_path} && git rev-parse --abbrev-ref HEAD 2>/dev/null | sed '/./ s/.*/#[fg=green] & #[fg=default]|/')"
      set -ga status-right " %Y-%m-%d %H:%M "
      set -ga status-right-length 150

      # Window Status: Format with pane path and zoom indicator
      setw -g window-status-activity-style fg=yellow
      setw -g window-status-bell-style     fg=red
      setw -g window-status-format         "#[fg=yellow]#I: #[fg=green]#[fg=white]#{?#{==:#W,fish},#{b:pane_current_path},#W #{b:pane_current_path}} #{?window_zoomed_flag, , }"
      setw -g window-status-current-format "#[fg=brightyellow,bold,underscore]#I: #[fg=brightgreen]#[fg=brightwhite,bold,underscore]#{b:pane_current_path} #W#{?window_zoomed_flag, , }"
      setw -g window-status-separator      "#[fg=brightwhite,bold]  "

      # Pane Border: Format with path, command and zoom indicator
      set -g pane-border-status top
      set -gF pane-border-style '#{?pane_synchronized,fg=red,fg=white}'
      set -gF pane-active-border-style '#{?pane_synchronized,fg=brightred,fg=green}'
      set -g pane-border-format " #{pane_current_path}#{?#{!=:#W,fish}, → #{pane_current_command},}#{?window_zoomed_flag, (), } "

      #-----------------------------------------------------------
      # Keybindings
      #-----------------------------------------------------------
      # List clients (bound to C to avoid conflict)
      bind C list-clients

      # Rename window on R (avoid conflict with reload)
      bind r command-prompt "rename-window %%"
      bind w list-windows

      # Split panes with current directory
      bind - split-window -v -c "#{pane_current_path}"
      bind \\ split-window -h -c "#{pane_current_path}"
      bind '"' choose-window
      bind : command-prompt

      # Toggle synchronize-panes with *
      bind * setw synchronize-panes

      # Toggle pane border status with P
      bind P set pane-border-status

      # Copy mode: Begin selection (vi mode)
      bind-key -T copy-mode-vi v send-keys -X begin-selection

      if-shell "uname | grep -q Darwin" {
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
        bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
      } {
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      }

      # Open lazygit popup with key 'g'
      bind -N "Open lazygit popup" g display-popup -d '#{pane_current_path}' -w95% -h95% -E lazygit

      #-----------------------------------------------------------
      # Floating Window Hooks & Toggle
      #-----------------------------------------------------------
      set-hook -g pane-died 'run-shell "~/.config/tmux/scripts/floating_close.sh pane-died floating_pane_#{hook_pane}"'
      set-hook -g pane-exited 'run-shell "~/.config/tmux/scripts/floating_close.sh pane-exited floating_pane_#{hook_pane}"'
      bind-key -n -N 'Toggle floating window' M-i if-shell -F '#{m:floating_pane_*,#{session_name},}' {
          detach-client
      } {
          # Create a new window and start the floating session
          display-popup -d "#{pane_current_path}" -xC -yC -w 80% -h 75% -E "tmux new-session -e 'TMUX_POPUP=1' -A -s $(tmux display-message -p 'floating_pane_#{pane_id}') 'tmux set status off; $SHELL'"
      }
      unbind z
      bind -n M-z resize-pane -Z

      # Navigation: Use Alt-arrow keys (no prefix) to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Navigation: Shift arrow keys and Alt-vim keys for window switching
      bind -n S-Left  previous-window
      bind -n S-Right next-window
    '';
  };

  xdg.configFile = lib.mkIf config.programs.tmux.enable {
    "tmux/scripts/floating_close.sh" = {
      text = ''
        #!/bin/bash
        tmux wait -L pane_wait
        hook_name=$1
        session_name=$2

        # Check if the session exists
        if tmux has-session -t "$session_name" 2>/dev/null; then
            # Kill the session
            tmux kill-session -t "$session_name"
            tmux display-message "$hook_name: Session '$session_name' killed."
        fi
        tmux wait -U pane_wait
      '';
      executable = true;
    };
  };
}
