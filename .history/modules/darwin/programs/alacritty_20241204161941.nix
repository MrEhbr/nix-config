{ pkgs, lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.fish}/bin/fish";
      window = {
        option_as_alt = "Both";
        decorations = "full";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 1.0;
        startup_mode = "Fullscreen";
      };

      scrolling.history = 10000;

      font = {
        bold = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Bold";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Bold Italic";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Italic";
        };
        normal = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "0x1f1f28";
          foreground = "0xdcd7ba";
        };
        normal = {
          black = "0x090618";
          red = "0xc34043";
          green = "0x76946a";
          yellow = "0xc0a36e";
          blue = "0x7e9cd8";
          magenta = "0x957fb8";
          cyan = "0x6a9589";
          white = "0xc8c093";
        };
        bright = {
          black = "0x727169";
          red = "0xe82424";
          green = "0x98bb6c";
          yellow = "0xe6c384";
          blue = "0x7fb4ca";
          magenta = "0x938aa9";
          cyan = "0x7aa89f";
          white = "0xdcd7ba";
        };
        selection = {
          background = "0x2d4f67";
          foreground = "0xc8c093";
        };
        indexed_colors = [
          { index = 16; color = "0xffa066"; }
          { index = 17; color = "0xff5d62"; }
        ];
      };
    };
  };
}