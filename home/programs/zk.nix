{ config, lib, pkgs, ... }: {
  options.my.programs.zk.enable = lib.mkEnableOption "zk";

  config = lib.mkIf config.my.programs.zk.enable {
    programs.zk = {
      enable = true;
      settings = {
        notebook.dir = "~/Notes";
        tool = {
          shell = "${pkgs.fish}/bin/fish";
        };
      };
    };
  };
}
