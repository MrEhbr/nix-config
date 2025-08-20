{ pkgs, pkgsStable, ... }:

let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages ++ (with pkgs; [
  reattach-to-user-namespace
  dockutil
  k9s
  sops
  kubectl
  kubernetes-helm
  tailscale
  darwin.libiconv
  glab
  timewarrior
  pngpaste
  darwin.trash
  csvlens
  postman
  iina
  code-cursor
  # Custom packages
  macism
  tailspin # Terminal-based log viewer
  claude-code # AI code assistant
  ccusage # Claude Code usage statistics
  gemini-cli # AI code assistant
  plantuml
  imagemagick
  luajitPackages.magick
  kickstart

]) ++ (with pkgsStable; [
  presenterm
])
