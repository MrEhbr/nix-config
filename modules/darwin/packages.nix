{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  reattach-to-user-namespace
  alacritty
  wezterm
  dockutil
  pam-reattach
  im-select # from overlay
  darwin.libiconv
  glab
  gh
]
