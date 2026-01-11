{ config, pkgs, lib, user, ... }:

let
  shared-files = import ../shared/files.nix { inherit user config pkgs; };

in
{
  _module.args.user = user;
  
  imports = [
    ../shared/home-manager.nix
  ];
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { };
    file = shared-files // import ./files.nix { inherit user pkgs; };
    stateVersion = "25.05";
    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      GOPATH = "$HOME/Go";
      GOBIN = "$HOME/Go/bin";
      BUN_INSTALL = "$HOME/.bun";
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

  programs = {
    tmux.enable = false;
  };

}
