{ ... }:
{
  imports = [
    ./packages.nix
    ./programs/fish
    ./programs/neovim.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/atuin.nix
    ./programs/eza.nix
    ./programs/direnv.nix
    ./programs/bat.nix
    ./programs/btop.nix
    ./programs/git.nix
    ./programs/gh.nix
    ./programs/ssh.nix
    ./programs/tmux
    ./programs/sesh.nix
    ./programs/fzf.nix
    ./programs/colima.nix
    ./programs/k9s.nix
    ./programs/zk.nix
    ./programs/lazygit.nix
    ./programs/ghostty.nix
    ./programs/revdiff.nix
    ./programs/aerospace.nix
    ./files.nix
    ./work.nix
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    GOPATH = "$HOME/Go";
    GOBIN = "$HOME/Go/bin";
    BUN_INSTALL = "$HOME/.bun";
  };
}
