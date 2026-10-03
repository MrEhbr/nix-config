{ ... }:
{
  imports = [
    ./packages.nix
    ./programs/fish
    ./programs/shell.nix
    ./programs/git.nix
    ./programs/gh.nix
    ./programs/ssh.nix
    ./programs/tmux
    ./programs/kitty.nix
    ./programs/sesh.nix
    ./programs/fzf.nix
    ./programs/colima.nix
    ./programs/k9s.nix
    ./programs/zk.nix
    ./programs/lazygit.nix
    ./programs/ghostty.nix
    ./programs/revdiff.nix
    ./files.nix
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    GOPATH = "$HOME/Go";
    GOBIN = "$HOME/Go/bin";
    BUN_INSTALL = "$HOME/.bun";
  };
}
