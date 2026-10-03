{ config, lib, ... }:

{
  options.my.programs.btop.enable = lib.mkEnableOption "btop";

  config = lib.mkIf config.my.programs.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "kanagawa-wave";
        vim_keys = true;
        proc_tree = true;
        presets = "cpu:0:default,proc:1:default cpu:0:default,mem:0:tty,proc:1:default";
      };
    };
  };
}
