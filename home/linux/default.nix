{ pkgs, user, ... }:

{
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

  programs = {
    gpg.enable = true;
  };

}
