{ config, lib, ... }:

{
  options.my.programs.eza.enable = lib.mkEnableOption "eza";

  config = lib.mkIf config.my.programs.eza.enable {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "-g"
      ];
      icons = "auto";
      git = true;
    };
  };
}
