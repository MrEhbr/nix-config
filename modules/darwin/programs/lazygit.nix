{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        nerdFontsVersion = "3";
      };
      customCommands = [ ];
      git = {
        commit = {
          signOff = true;
        };
        pagers = [
          {
            externalDiffCommand = "difft --color=always";
          }
        ];
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
      };
    };
  };
}
