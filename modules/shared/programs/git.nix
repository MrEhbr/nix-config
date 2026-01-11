{ lib, pkgs, user, ... }:
let
  name = "Aleksei Burmistrov";
  email = "mr.ehbr@gmail.com";
in
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    ignores = [
      # General
      ".DS_Store"
      "Thumbs.db"
      "*.log"
      "*.tmp"
      "*.swp"
      "*.bak"
      "*.old"
      "*.orig"

      # Compiled source
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"

      # Packages
      "*.7z"
      "*.dmg"
      "*.gz"
      "*.iso"
      "*.jar"
      "*.tar"
      "*.zip"

      # Temporary files
      "*.cache"
      "*.tmp"
      "*.temp"
      "*.pid"
      "*.seed"
      "*~"
      "*#"
      ".#*"

      # Logs
      "logs/"
      "*.log"

      # OS generated files
      ".DS_Store"
      "*.DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"
      "$RECYCLE.BIN/"
      "*.lnk"

      # IDEs and editors
      ".vscode/"
      ".idea/"
      "*.suo"
      "*.ntvs*"
      "*.njsproj"
      "*.sln"
      "*.sw?"
      ".project"
      ".classpath"
      ".cproject"
      ".settings/"
      "out/"
      "bin/"

      # Dependency directories
      "node_modules/"
      "vendor/"
      ".tmp/"
      "dist/"

      # Generated files
      "coverage/"
      "*.iml"
      "*.ipr"
      "*.iws"
      "*.sublime-workspace"
      "*.sublime-project"
      "*.vs/"
      "*.vscode/"
      "*.patch"
      "*.diff"
      ".tmp/"
      "dist/"
      "build/"
      "debug/"
      "release/"
      "target/"
      "*.d.ts"
      "*.js.map"
      "*.tsbuildinfo"

      # System Files
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"
      "$RECYCLE.BIN/"
      "*.lnk"

      # Others
      ".env"
      ".envrc"
      ".direnv/"
      ".devenv/"
      ".env.*"
    ];
    lfs.enable = true;

    includes = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [
      {
        # use diffrent email & name for work
        path = "/Users/${user}/Work/.gitconfig";
        condition = "gitdir:/Users/${user}/Work/";
      }
    ];

    settings = {
      user = {
        name = name;
        email = email;
      };
      alias = {
        # common aliases
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      };
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      url = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        "git@gitlab.mobbtech.com:".insteadOf = "https://gitlab.mobbtech.com/";
        "git@github.com:".insteadOf = "https://github.com/";
      };
      safe = {
        directory = "/etc/nixos";
      };
      merge.ours = {
        driver = true;
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
    options = {
      # display = "inline";
    };
  };
}
