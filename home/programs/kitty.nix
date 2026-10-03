{ pkgs, lib, config, ... }:
{
  options.my.programs.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.my.programs.kitty.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
      themeFile = "Kanagawa";
      keybindings = { };
      settings = lib.mkMerge [
        {
          font_family = "JetBrainsMono Nerd Font Mono";
          shell = "${pkgs.fish}/bin/fish";
          scrollback_lines = 10000;
          window_border_width = "0.5pt";
          draw_minimal_borders = "no";
          window_margin_width = 0;
          window_padding_width = 3;
          hide_window_decorations = "titlebar-only";
          confirm_os_window_close = 0;
          shell_integration = "disabled";
        }
        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          font_size = 10;
        })
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          font_size = 14;
          macos_option_as_alt = "both";
        })
      ];
    };
  };
}
