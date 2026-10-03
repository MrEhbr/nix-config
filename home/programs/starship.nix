{ config, lib, ... }:

{
  options.my.programs.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.my.programs.starship.enable {
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

        directory = {
          style = "blue";
        };
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
          detect_folders = [
            ".docker"
            "docker"
          ];
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
  };
}
