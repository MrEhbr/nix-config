{ inputs, config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    sideloadInitLua = true;
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
