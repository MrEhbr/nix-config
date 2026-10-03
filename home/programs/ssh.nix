{ config, pkgs, lib, user, constants, ... }:
let
  home = if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/${user}"
    else "/home/${user}";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "${home}/.ssh/config_external" ];
    settings = lib.mkMerge [
      {
        "*" = {
          AddKeysToAgent = "yes";
          ForwardAgent = true;
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
          IdentitiesOnly = true;
          IdentityFile = [ "${home}/.ssh/id_github" ];
        };
      }

      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        "gitlab.mobbtech.com" = {
          IdentitiesOnly = true;
          IdentityFile = [ "${home}/.ssh/id_work_gitlab" ];
        };
      })
    ];
  };
}
