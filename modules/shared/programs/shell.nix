{ inputs, config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

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
      cc_serena = "command claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)";
      claude = "claude --mcp-config $HOME/.claude/.mcp.json";
      btop = "btop --preset 1";
    };

    functions = {
      exit_fn = ''
        if test -n "$TMUX_POPUP"
          set -l session_name (tmux display-message -p '#S')
          set -l pane_count (tmux list-panes | wc -l)
          if test $pane_count -eq 1
            tmux detach-client
            tmux kill-session -t $session_name
          else
            builtin exit
          end
        else
          builtin exit
        end
      '';
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

      if type -q tmux
        if not set -q TMUX
          set -g TMUX tmux new-session -d -s base
          eval $TMUX
          tmux attach-session -d -t base
        end
      end
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
      ${pkgs.atuin}/bin/atuin init fish | sed 's/-k up/up/' | source

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

  programs.starship = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      add_newline = true;

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$nix_shell"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$line_break"
        "$character"
      ];
      right_format = "$cmd_duration $status";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      status = {
        disabled = false;
        format = "[$symbol $status]($style)";
        symbol = "✗";
        map_symbol = true;
      };

      directory = { style = "blue"; };
      nix_shell = {
        style = "bold blue";
        symbol = "nix ";
        format = "via [$symbol]($style)";
      };
      git_branch = {
        format = "[$branch ]($style)";
        style = "bright-black";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      docker_context = {
        format = "[$symbol $context]($style)";
        symbol = " ";
        detect_folders = [ ".docker" "docker" ];
      };
      aws = {
        disabled = true;
        format = "on [$symbol($profile )]($style)";
        style = "bold blue";
        symbol = "🅰 ";
      };
      kubernetes = {
        format = "on [⛵$context \($namespace\)]($style) ";
        disabled = true;
        contexts = [
          {
            context_pattern = ".*INT.*";
            style = "dimmed green";
            context_alias = "INT";
          }
          {
            context_pattern = ".*PROD.*";
            style = "dimmed red";
            context_alias = "PROD";
          }
        ];
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      enter_accept = false;
      auto_sync = true;
      auto_sync_interval = "1h";
      keymap_mode = "vim-insert";
      sync_address = "https://atuin.ehbr.cloud";
      sync.records = true;
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    extraOptions = [ "--group-directories-first" "-g" ];
    icons = "auto";
    git = true;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "5m";
        log_format = "-";
      };
    };
    stdlib = ''
      declare -A direnv_layout_dirs
        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "${config.xdg.cacheHome}"/direnv/layouts/
          echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
      }
    '';
  };

  programs.bat = {
    enable = true;
    themes = {
      kanagawa = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "7b411f9e66c6f4f6bd9771f3e5affdc468bcbbd2";
          sha256 = "sha256-kV+hNZ9tgC8bQi4pbVWRcNyQib0+seQrrFnsg7UMdBE=";
        };
        file = "/extras/kanagawa.tmTheme";
      };
    };

    config = {
      theme = "kanagawa";
      pager = "less -FR";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "kanagawa-wave";
      vim_keys = true;
      proc_tree = true;
      presets = "cpu:0:default,proc:1:default cpu:0:default,mem:0:tty,proc:1:default";
    };
  };
}
