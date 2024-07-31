{ pkgs, lib, ... }:
let
  tmux-sessionx = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sessionx";
    version = "30-08-2024";
    src = pkgs.fetchFromGitHub
      {
        owner = "omerxx";
        repo = "tmux-sessionx";
        rev = "ecc926e7db7761bfbd798cd8f10043e4fb1b83ba";
        sha256 = "sha256-S/1mcmOrNKkzRDwMLGqnLUbvzUxcO1EcMdPwcipRQuE=";
      };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postPatch = ''
      substituteInPlace sessionx.tmux \
        --replace "\$CURRENT_DIR/scripts/sessionx.sh" "$out/share/tmux-plugins/sessionx/scripts/sessionx.sh"
      substituteInPlace scripts/sessionx.sh \
        --replace "/tmux-sessionx/scripts/preview.sh" "$out/share/tmux-plugins/sessionx/scripts/preview.sh"
      substituteInPlace scripts/sessionx.sh \
        --replace "/tmux-sessionx/scripts/reload_sessions.sh" "$out/share/tmux-plugins/sessionx/scripts/reload_sessions.sh"
    '';

    postInstall = ''
      chmod +x $target/scripts/sessionx.sh
      wrapProgram $target/scripts/sessionx.sh \
        --prefix PATH : ${with pkgs; lib.makeBinPath [ zoxide fzf gnugrep gnused coreutils ]}
      chmod +x $target/scripts/preview.sh
      wrapProgram $target/scripts/preview.sh \
        --prefix PATH : ${with pkgs; lib.makeBinPath [ coreutils gnugrep gnused ]}
      chmod +x $target/scripts/reload_sessions.sh
      wrapProgram $target/scripts/reload_sessions.sh \
        --prefix PATH : ${with pkgs; lib.makeBinPath [ coreutils gnugrep gnused ]}
    '';

  };
  tmux-floax = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "floax";
    version = "30-08-2024";

    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-floax";
      rev = "1f35df835a4f5984512a95f568340954f1869f69";
      sha256 = "sha256-i8qAcqosezyDl2mMPHMLwUHQqX0OonHNUOr4UzCWsSU=";
    };
  };
in 
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tmux-fzf
      yank
      cpu
      {
        plugin = tmux-floax;
        extraConfig = ''
set -g @floax-bind '-n M-i'
set -g @floax-bind-menu '-n M-I'
set -g @floax-width '80%'
set -g @floax-height '80%'
set -g @floax-border-color 'magenta'
set -g @floax-text-color 'blue'
set -g @floax-change-path 'true'
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
set -g @sessionx-auto-accept 'off'
set -g @sessionx-custom-paths '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault'
set -g @sessionx-bind 'l'
set -g @sessionx-window-height '85%'
set -g @sessionx-window-width '75%'
set -g @sessionx-zoxide-mode 'on'
set -g @sessionx-custom-paths-subdirectories 'false'
set -g @sessionx-filter-current 'false'
set -g @sessionx-preview-location 'right'
set -g @sessionx-preview-ratio '55%'

set -g @sessionx-bind-tree-mode 'ctrl-w'
set -g @sessionx-bind-new-window 'ctrl-c'
set -g @sessionx-bind-kill-session 'ctrl-d'
        '';
    }
    ];

    terminal = "tmux-256color";
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    clock24 = true;
    customPaneNavigationAndResize = true;
    mouse = true;
    historyLimit = 50000;
    extraConfig = ''
set-option -g default-terminal 'screen-256color'
set-option -g terminal-overrides ',xterm-256color:RGB'

set -g message-style 'bg=default,fg=yellow,bold'
set -g status-style  'bg=default'

# Appearance
set -g message-style 'bg=default,fg=yellow,bold'
set -g status-style  'bg=default'

set -g pane-border-status top
set -gF pane-border-style '#{?pane_synchronized,fg=red,fg=white}'
set -gF pane-active-border-style '#{?pane_synchronized,fg=brightred,fg=green}'
set -g pane-border-format " #{pane_current_path}#{?#{!=:#W,fish}, → #{pane_current_command},}#{?window_zoomed_flag, (), } "

setw -g mode-style 'bg=green, fg=black, bold'

set -g status-interval 4
set -g status-position bottom


set -g status-left '#{?client_prefix,#[bg=#d65c0d],#[bg=default]} #[fg=brightwhite,bold]#S#[fg=none]'
set -ga status-left '#[bg=default]#{?client_prefix,#[fg=#d65c0d] ,#[fg=default]  }'
set -g status-left-length 80

setw -g window-status-activity-style fg=yellow
setw -g window-status-bell-style     fg=red
setw -g window-status-format         "#[fg=yellow]#I #[fg=green]#[fg=white]#{?#{==:#W,fish},#{b:pane_current_path},#W #{b:pane_current_path}} #{?window_zoomed_flag, , }"
setw -g window-status-current-format "#[fg=brightyellow,bold,underscore]#I: #[fg=brightgreen]#[fg=brightwhite,bold,underscore]#{b:pane_current_path} #W#{?window_zoomed_flag, , }"
setw -g window-status-separator      "#[fg=brightwhite,bold]  "
set -g status-justify left


set -g detach-on-destroy off     # don't exit from tmux when closing a session
set -g renumber-windows on       # renumber all windows when any window is closed
set -g set-clipboard on          # use system clipboard

# set vi-mode
set-window-option -g mode-keys vi

set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM

set -g pane-active-border-style 'fg=magenta,bg=default'
set -g pane-border-style 'fg=brightblack,bg=default'

# Keybindings
bind * list-clients

bind r command-prompt "rename-window %%"
bind w list-windows
bind - split-window -v -c "#{pane_current_path}"
bind \\ split-window -h -c "#{pane_current_path}"
bind '"' choose-window
bind : command-prompt
bind * setw synchronize-panes
bind P set pane-border-status
bind-key -T copy-mode-vi v send-keys -X begin-selection

bind -N "Open lazygit popup" g display-popup -d '#{pane_current_path}' -w80% -h90% -E lazygit

# Rebind zoom pane to Alt-z
unbind z
bind -n M-z resize-pane -Z

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Shift Alt vim keys to switch windows
bind -n M-H previous-window
bind -n M-L next-window

# Reload tmux config
bind r source-file ~/.tmux.local.conf \; display-message "Config reloaded..."
if '[ -e ~/.tmux.local.conf ]' 'source ~/.tmux.local.conf'
    '';
  };
  xdg.configFile = {
    "tmux/tmux.conf".text = lib.mkOrder 600 ''
      set -g status-right "#[bg=default,fg=brightblue] #{pane_current_path} #[bg=default,fg=gray]|"
      set -ga status-right "#[fg=gray,bold]#{?pane_mode,#[fg=default] #{pane_mode} #[bg=default]#[fg=gray]|,}"
      set -ga status-right " CPU: #{cpu_fg_color}#{cpu_percentage} #[fg=default]RAM: #{ram_fg_color}#{ram_percentage} #[bg=default,fg=gray]| #[bg=default,fg=gray]%Y-%m-%d %H:%M"
      set -ga status-right-length 150
    '';
  };
}
