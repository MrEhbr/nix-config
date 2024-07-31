{ config, pkgs, lib, ... }:

let
  user = "ehbr";
  xdg_configHome = "/home/${user}/.config";
  shared-files = import ../shared/files.nix { inherit user config pkgs; };

in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { };
    file = shared-files // import ./files.nix { inherit user pkgs; };
    stateVersion = "21.05";
  };

  # Screen lock
  services = {
    # Auto mount devices
    udiskie.enable = true;
  };

  programs = { gpg.enable = true; };

  imports = import ../shared/home-manager.nix;


}
