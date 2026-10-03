{ pkgs, ... }:

{
  imports = [
    ../.
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { };
    stateVersion = "25.05";
  };

  manual.manpages.enable = true;
}
