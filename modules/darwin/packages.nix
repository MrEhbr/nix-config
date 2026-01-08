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
  glab
  plantuml

  # AI assistants
  # claude-code # usefull updates ships to quickly
  # codex
  github-copilot-cli

  # API / HTTP clients
  # bruno
  # bruno-cli
  postman

  # graphics
  iina
  imagemagick
  luajitPackages.magick
  kickstart

  # Data 
  csvlens
  tabiew
  sqlit-tui

  # Productivity 
  timewarrior

  # chromium
  # Custom packages
  macism
]) ++ (with pkgsStable; [
  # Presentation
  presenterm
]) 
