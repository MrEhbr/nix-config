{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.packages;

  groups = with pkgs; {
    cli = [
      procs
      jless # pager for JSON (or YAML) data
      coreutils
      wget
      xh
      unzip
      tlrc
      dua
      dust
      timg # view images from the terminal
      imagemagick
      hyperfine # Benchmarking tool
      tree-sitter
      gum
      yazi
      glow
      ffmpeg

      # Encryption and security tools
      age
      sops
      openssl

      # Text and terminal utilities
      difftastic
      delta
      just
      htop
      jq
      yq-go
      ripgrep
      fd
      repgrep
      tree
      onefetch

      # Custom tools
      dev-env
    ];

    dev = [
      act # Github Actions local runner
      # sqlit-tui
      sccache # Compilation cache

      # Node.js development tools
      nodejs_24
      bun
      uv

      go
      rustup
      rustc
      lua5_4
    ];

    docker = [
      lazydocker
      docker
      docker-compose
      docker-buildx
    ];

    k8s = [
      kubectl
    ];

    tools = [
      tailscale

      # logs
      tailspin

      # code tooling
      ast-grep
      glab
      plantuml
      luajitPackages.magick

      # Data
      csvlens
      tabiew

      # Productivity
      timewarrior
      kickstart
    ];

    gui = [
      postman
      iina
    ];
  };
in
{
  options.my.packages = lib.mapAttrs (name: _: {
    enable = lib.mkEnableOption "${name} packages";
  }) groups;

  config.home = {
    packages = lib.concatLists (
      lib.mapAttrsToList (name: pkgs: lib.optionals cfg.${name}.enable pkgs) groups
    );

    sessionVariables = lib.mkIf cfg.dev.enable {
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_DIR = "$HOME/.cache/sccache";
      RAINFROG_CONFIG = "$HOME/.config/rainfrog";
    };
  };
}
