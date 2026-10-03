{
  config,
  lib,
  constants,
  ...
}:
let
  home = config.home.homeDirectory;
in
{
  options.my.programs.ssh.enable = lib.mkEnableOption "ssh";

  config = lib.mkIf config.my.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "${home}/.ssh/config_external" ];
      settings = lib.mkMerge [
        {
          "*" = {
            AddKeysToAgent = "yes";
            ForwardAgent = false;
          };
        }
        {
          "github.com" = {
            IdentitiesOnly = true;
            IdentityFile = [ "${home}/.ssh/id_github" ];
          };
        }
        {
          ${constants.domain} = {
            ForwardAgent = true;
            IdentitiesOnly = true;
            IdentityFile = [ "${home}/.ssh/id_github" ];
          };
        }
      ];
    };
  };
}
