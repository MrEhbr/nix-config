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
  ansible
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
  timg
  sccache # Compilation cache


  # Encryption and security tools
  age
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
  lua5_4

  # Text and terminal utilities
  just
  htop
  jq
  ripgrep
  repgrep
  tree
  eza
  zoxide
  atuin

  # Custom tools
  dev-env
]
