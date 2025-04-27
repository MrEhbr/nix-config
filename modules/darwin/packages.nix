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
  colima
  darwin.trash
  csvlens
  postman
  iina
  code-cursor
  # Custom packages
  macism
]) ++ (with pkgsStable; [
  presenterm
])
