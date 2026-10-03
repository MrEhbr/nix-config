{ pkgs, pkgsStable, ... }:

{
  imports = [
    ../.
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { pkgsStable = pkgsStable; };

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      GOPATH = "$HOME/Go";
      GOBIN = "$HOME/Go/bin";
      BUN_INSTALL = "$HOME/.bun";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_DIR = "$HOME/.cache/sccache";
      RAINFROG_CONFIG = "$HOME/.config/rainfrog";
    };

    stateVersion = "25.05";
  };

  manual.manpages.enable = true;
}
