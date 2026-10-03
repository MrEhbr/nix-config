{ config, pkgs, lib, user, ... }:

{
  _module.args.user = user;

  imports = [ ../. ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { };
    stateVersion = "25.05";
    sessionVariables = {
      DIRENV_WARN_TIMEOUT = "5m";
      DIRENV_LOG_FORMAT = "";
    };

  };

  # Screen lock
  services = {
    # Auto mount devices
    udiskie.enable = true;
  };

  programs = { gpg.enable = true; };


}
