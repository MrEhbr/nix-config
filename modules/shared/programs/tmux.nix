{ pkgs, ... }:
let
  floatingCloseScript = pkgs.writeShellScript "floating-close" ''
    ${pkgs.tmux}/bin/tmux wait -L pane_wait
    hook_pane=$1
    # Parent pane exited - clean up its floating session if exists
    if [[ -n "$hook_pane" ]]; then
      floating_name="floating_pane_$hook_pane"
      ${pkgs.tmux}/bin/tmux kill-session -t "$floating_name" 2>/dev/null
    fi
    ${pkgs.tmux}/bin/tmux wait -U pane_wait
  '';

  # Abbreviate path: replace $HOME with ~, optionally truncate deep paths
  # Usage: abbreviate-path <path> [full]
  # If second arg is "full", shows complete path (no truncation)
  abbreviatePath = pkgs.writeShellScript "abbreviate-path" ''
    path="$1"
    path="''${path/#$HOME/\~}"
    if [ "$2" = "full" ]; then
      echo "$path"
    else
      IFS='/' read -ra parts <<<"$path"
      count=''${#parts[@]}
      if [ "$count" -gt 4 ]; then
        echo "…/''${parts[-3]}/''${parts[-2]}/''${parts[-1]}"
      else
        echo "$path"
      fi
    fi
  '';
in
{
  programs.tmux = {
    enable = true;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tmux-fzf
    ];

    shell = "${pkgs.fish}/bin/fish";
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    mouse = true;
    historyLimit = 50000;
    terminal = "tmux-256color";
    aggressiveResize = true;
    focusEvents = true;

    extraConfig = ''
      #-----------------------------------------------------------
      # Terminal & Color Settings (optimized for Ghostty)
      #-----------------------------------------------------------
      set -ga terminal-overrides ",xterm-ghostty:Tc:RGB"
      set -ga terminal-overrides ",tmux-256color:Tc:RGB"
      # Enable undercurl (both basic and with color support)
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set -g xterm-keys on

      #-----------------------------------------------------------
      # Basic Options & Pane Settings
      #-----------------------------------------------------------
      set -g allow-rename on
      set -g renumber-windows on
      set -g set-titles on
      set -g detach-on-destroy off
      set -g bell-action none
      set -g visual-bell off
      set -g visual-activity off
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      #-----------------------------------------------------------
      # Appearance & Status Bar Settings
      #-----------------------------------------------------------
      set -g message-style 'bg=default,fg=yellow,bold'
      set -g status-style  'bg=default'
      set -g status-interval 10
      set -g status-position bottom
      set -g status-justify left

      # Status Left: Session name with a colored segment when in prefix mode
      set -g status-left '#{?client_prefix,#[fg=#d65c0d]#[bg=#d65c0d],#[fg=default] }#[fg=brightwhite,bold]#S#[fg=none]'
      set -ga status-left '#[bg=default]#{?client_prefix,#[fg=#d65c0d] ,#[fg=default]  }'
      set -g status-left-length 80

      # Status Right: Path, git branch (if available) and time
      set -g status-right "#[fg=brightblue] #(${abbreviatePath} '#{pane_current_path}') #[fg=gray]|"
      set -ga status-right "#[fg=gray,bold]#{?pane_mode,#[fg=default] #{pane_mode} #[fg=gray]|,}"
      set -ga status-right "#(cd \"#{pane_current_path}\" && git rev-parse --abbrev-ref HEAD 2>/dev/null | sed '/./ s/.*/#[fg=green] & #[fg=default]|/')"
      set -ga status-right " %Y-%m-%d %H:%M "
      set -g status-right-length 150

      # Window Status: Format with pane path and zoom indicator
      setw -g window-status-activity-style fg=yellow
      setw -g window-status-bell-style     fg=red
      setw -g window-status-format         "#[fg=yellow]#I: #[fg=white]#{?#{==:#W,fish},#{b:pane_current_path},#{b:pane_current_path} #W}#{?window_zoomed_flag, , }"
      setw -g window-status-current-format "#[fg=brightyellow,bold,underscore]#I: #[fg=brightwhite,bold,underscore]#{b:pane_current_path} #W#{?window_zoomed_flag, , }"
      setw -g window-status-separator      "#[fg=brightwhite,bold]  "

      # Pane Border: Format with path, command and zoom indicator
      set -g pane-border-status top
      set -gF pane-border-style '#{?pane_synchronized,fg=red,fg=white}'
      set -gF pane-active-border-style '#{?pane_synchronized,fg=brightred,fg=green}'
      set -g pane-border-format " #(${abbreviatePath} '#{pane_current_path}' full)#{?#{!=:#W,fish}, → #{pane_current_command},}#{?window_zoomed_flag, (), } "

      #-----------------------------------------------------------
      # Keybindings
      #-----------------------------------------------------------
      # List clients (bound to C to avoid conflict)
      bind C list-clients

      # Reload config
      bind R source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # Rename window
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
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'pbcopy'
        bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'pbcopy'
      } {
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      }

      # Open lazygit popup with key 'g'
      bind -N "Open lazygit popup" g display-popup -d '#{pane_current_path}' -w95% -h95% -E lazygit

      #-----------------------------------------------------------
      # Floating Window Hooks & Toggle
      #-----------------------------------------------------------
      set-hook -g pane-died 'run-shell "${floatingCloseScript} #{hook_pane}"'
      set-hook -g pane-exited 'run-shell "${floatingCloseScript} #{hook_pane}"'
      bind-key -n -N 'Toggle floating window' M-i if-shell -F '#{m:floating_pane_*,#{session_name}}' {
          detach-client
      } {
          display-popup -d "#{pane_current_path}" -xC -yC -w 80% -h 75% -E "tmux new-session -e TMUX_POPUP=1 -A -s \$(tmux display-message -p 'floating_pane_#{pane_id}') 'tmux set status off; exec \$SHELL'"
      }
      unbind z
      bind -n M-z resize-pane -Z

      # Navigation: Shift arrow keys and Alt-vim keys for window switching
      bind -n S-Left  previous-window
      bind -n S-Right next-window
    '';
  };
}
