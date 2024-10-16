{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  tmux
  tmuxinator
  reattach-to-user-namespace
  alacritty
  dockutil
  pam-reattach
  im-select # from overlay
  darwin.libiconv
  glab
  gh
  timetrace
  bruno
  timewarrior
]
