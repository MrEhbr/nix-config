{ config, lib, ... }:

{
  options.my.programs.zoxide.enable = lib.mkEnableOption "zoxide";

  config = lib.mkIf config.my.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
