{ pkgs, ... }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  reattach-to-user-namespace
  dockutil
  darwin.libiconv
  glab
  timewarrior
  pngpaste
  colima

  iina
  # Custom packages
  macism
]
