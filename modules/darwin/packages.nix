{ pkgs, ... }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  reattach-to-user-namespace
  dockutil
  k9s
  kubectl
  kubernetes-helm
  tailscale
  darwin.libiconv
  glab
  timewarrior
  pngpaste
  colima

  iina
  # Custom packages
  macism
]
