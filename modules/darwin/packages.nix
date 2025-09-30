{ pkgs, pkgsStable, ... }:

let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages ++ (with pkgs; [
  # system integration
  darwin.libiconv
  darwin.trash
  dockutil
  pngpaste
  reattach-to-user-namespace

  # Networking
  tailscale

  # Security 
  sops

  # Kubernetes 
  k9s
  kubectl
  kubernetes-helm

  # logs
  tailspin
  # gonzo

  # code tooling
  ast-grep
  code-cursor
  glab
  plantuml

  # AI assistants
  (claude-code.override { nodejs_20 = nodejs_24; })
  gemini-cli
  codex

  # API / HTTP clients
  bruno
  bruno-cli
  postman

  # graphics
  iina
  imagemagick
  luajitPackages.magick
  kickstart

  # Data 
  csvlens

  # Productivity 
  timewarrior

  # chromium
  # Custom packages
  macism
]) ++ (with pkgsStable; [
  # Presentation
  presenterm
])
