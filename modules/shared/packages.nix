{ pkgs }:

with pkgs; [
  # General packages for development and system management
  git
  lazygit
  lazydocker
  act # Github Actions local runner
  bat
  bottom
  procs
  jless #  pager for JSON (or YAML) data
  coreutils
  delta
  wget
  # ansible
  just
  yazi
  httpie
  unzip
  postman
  bruno
  gh
  tlrc
  dua
  dust
  rainfrog # SQL TUI
  sccache # Compilation cache
  timg # view images from the terminal
  imagemagick

  # Encryption and security tools
  age
  sops
  openssl

  # Cloud-related tools and SDKs
  docker
  docker-compose
  docker-buildx

  # Media-related packages
  ffmpeg
  fd
  glow
  fzf

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodejs

  # Common dev tools
  go
  rustup
  rustc
  lua5_4

  # Text and terminal utilities
  just
  htop
  jq
  yq
  ripgrep
  repgrep
  tree
  eza
  zoxide
  atuin
  zk

  # Custom tools
  dev-env
]
