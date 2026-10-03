{ config, lib, pkgs, ... }:
let
  cfg = config.my.packages;

  groups = with pkgs; {
    cli = [
      git
      bat
      procs
      jless #  pager for JSON (or YAML) data
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
      eza
      onefetch
      zoxide
      atuin
      zk

      # Custom tools
      dev-env
    ];

    dev = [
      act # Github Actions local runner
      rainfrog # SQL TUI
      sccache # Compilation cache
      # d2
      # ansible

      # Node.js development tools
      # nodePackages.npm # globally install npm
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
      k9s
      kubectl
      # kubernetes-helm
    ];

    tools = [
      tailscale

      # logs
      tailspin
      # gonzo

      # code tooling
      ast-grep
      glab
      plantuml
      luajitPackages.magick

      # AI assistants
      # claude-code # usefull updates ships to quickly
      # codex
      # github-copilot-cli

      # Data
      csvlens
      # sqlit-tui
      tabiew

      # Productivity
      timewarrior
      kickstart
    ];

    gui = [
      # bruno
      # bruno-cli
      postman
      iina
      # chromium
    ];
  };
in
{
  options.my.packages = lib.mapAttrs (name: _: { enable = lib.mkEnableOption "${name} packages"; }) groups;

  config.home.packages = lib.concatLists (lib.mapAttrsToList (name: pkgs: lib.optionals cfg.${name}.enable pkgs) groups);
}
