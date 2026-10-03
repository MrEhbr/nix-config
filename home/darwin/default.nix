{ pkgs, pkgsStable, config, lib, user, ... }:

{
  imports = [
    ../.
    ../programs/colima.nix
    ../programs/k9s.nix
    ../programs/zk.nix
    ../programs/lazygit.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { pkgsStable = pkgsStable; };
    file = import ./files.nix { inherit user config pkgs lib; };

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

  programs = {
    tmux.enable = true;
  };

  manual.manpages.enable = true;
}
