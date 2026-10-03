{ pkgs, ... }:

with pkgs;
[
  # system integration
  darwin.libiconv
  darwin.trash
  dockutil
  pngpaste
  reattach-to-user-namespace

  # Custom packages
  macism
]
