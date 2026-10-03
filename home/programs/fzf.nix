{ config, lib, ... }:

{
  options.my.programs.fzf.enable = lib.mkEnableOption "fzf";

  config = lib.mkIf config.my.programs.fzf.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--style=minimal"
        "--ansi"
        "--color=current-bg:-1,current-fg:yellow:bold,gutter:-1"
        "--color=hl:cyan,hl+:cyan:bold"
        "--color=pointer:yellow,marker:yellow,prompt:magenta"
        "--color=info:blue:dim,separator:blue:dim,preview-border:blue:dim"
      ];
    };
  };
}
