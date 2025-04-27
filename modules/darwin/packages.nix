{ pkgs, ... }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
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
  postman
  iina
  # Custom packages
  macism
]
