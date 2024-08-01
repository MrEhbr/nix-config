{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # App and package management
  gnumake
  libgcc
  glibc
  gcc
  cmake
  home-manager

  # Media and design tools
  fontconfig
  font-manager

  # Testing and development tools
  direnv

  # Text and terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  libnotify
  smartmontools
  parted
  ntfs3g
  udevil
  samba
  cifs-utils
  mergerfs
  apparmor-pam
]
