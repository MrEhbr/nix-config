{ user, config, pkgs, constants, ... }:
{
  imports = [
    ./programs/fish
    ./programs/shell.nix
    ./programs/git.nix
    ./programs/gh.nix
    ./programs/ssh.nix
    ./programs/tmux
    ./programs/kitty.nix
    ./programs/sesh.nix
    ./programs/fzf.nix
  ];

  home.file = import ./files.nix { inherit user config pkgs constants; };
}
