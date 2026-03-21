{ config, pkgs, lib, ... }:

{
  imports = [ ./functions.nix ];

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];
    shellAliases = {
      cat = lib.mkIf config.programs.bat.enable "bat --style=plain --paging=never";
      grep = "grep --color=auto";
      groot = "cd (git rev-parse --show-cdup)";
      rg = "rg -p --glob '!node_modules/*' --color=auto";
      shell = "nix-shell -p";
      exit = "exit_fn";
      claude = "claude --mcp-config $HOME/.claude/.mcp.json";
      btop = "btop --preset 1";
    };

    shellInit = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
      source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    '';
    interactiveShellInit = ''
      set fish_greeting
      set -gx HISTORY_IGNORE "pwd:ls:cd:z:clear"

      fish_add_path -g /usr/local/bin
      fish_add_path -g $HOME/bin
      fish_add_path -g $HOME/.cargo/bin
      fish_add_path -g $GOBIN
      fish_add_path -g $BUN_INSTALL/bin
      fish_add_path -g $HOME/.flutter/bin
      fish_add_path -g $HOME/.pub-cache/bin
      fish_add_path -g $HOME/.bun/bin
      fish_add_path -g $HOME/.local/bin
      fish_add_path -g $HOME/.opencode/bin

      if type -q tmux; and not set -q TMUX; and not set -q NOTMUX
        if not set -q SSH_CONNECTION
          tmux new-session -d -s base 2>/dev/null
          exec tmux attach-session -t base
        end
      end
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
      ${pkgs.atuin}/bin/atuin init fish | sed 's/-k up/up/' | source
      ${pkgs.wtp}/bin/wtp shell-init fish | source

      abbr --add wa 'wtp add'
      abbr --add --set-cursor --function _wtp_add_branch_abbr -- wab

      # Kanagawa Fish shell theme
      # A template was taken and modified from Tokyonight:
      # https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
      set -l foreground DCD7BA normal
      set -l selection 2D4F67 brcyan
      set -l comment 727169 brblack
      set -l red C34043 red
      set -l orange FF9E64 brred
      set -l yellow C0A36E yellow
      set -l green 76946A green
      set -l purple 957FB8 magenta
      set -l cyan 7AA89F cyan
      set -l pink D27E99 brmagenta

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
    '';
  };
}
