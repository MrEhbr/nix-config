{ pkgs, lib, config, ... }:
let
  configPath = ../config/aerospace/aerospace.toml;
  cfg = config.services.aerospace;
in
{
  services.aerospace = {
    enable = true;
    settings = { };
  };

  launchd.user.agents.aerospace = {
    path = [ cfg.package ];
    command = lib.mkForce "${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path ${configPath}";
  };

  # services.jankyborders = {
  #   enable = true;
  #   width = 3.0;
  #   active_color = "gradient(top_left=0xff957FB8,bottom_right=0xff7FB4CA)";
  #   inactive_color = "gradient(top_right=0x998CA6D8,bottom_left=0x995F6F88)";
  #   hidpi = true;
  #   ax_focus = true;
  #   blacklist = [ "iPhone Mirroring" ];
  # };

}
