{ pkgs, ... }:

{
  imports = [
    ../.
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { };

    sessionVariables = {
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_DIR = "$HOME/.cache/sccache";
      RAINFROG_CONFIG = "$HOME/.config/rainfrog";
    };

    stateVersion = "25.05";
  };

  manual.manpages.enable = true;
}
