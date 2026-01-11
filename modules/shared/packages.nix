{ pkgs }:

with pkgs; [
  # General packages for development and system management
  git
  lazydocker
  act # Github Actions local runner
  bat
  procs
  jless #  pager for JSON (or YAML) data
  coreutils
  difftastic
  wget
  # ansible
  just
  xh
  unzip
  gh
  tlrc
  dua
  dust
  dua
  rainfrog # SQL TUI
  sccache # Compilation cache
  timg # view images from the terminal
  imagemagick
  hyperfine # Benchmarking tool
  tree-sitter

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
  glow
  fzf

  # Node.js development tools
  # nodePackages.npm # globally install npm
  nodejs_24
  bun
  uv

  # Common dev tools
  go
  rustup
  rustc
  lua5_4

  # Text and terminal utilities
  just
  htop
  jq
  yq-go
  ripgrep
  fd
  repgrep
  tree
  eza
  zoxide
  atuin
  zk

  # Custom tools
  dev-env
]
