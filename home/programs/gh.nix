{ config, lib, pkgs, ... }:

{
  options.my.programs.gh.enable = lib.mkEnableOption "gh";

  config = lib.mkIf config.my.programs.gh.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-enhance
      ];
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
