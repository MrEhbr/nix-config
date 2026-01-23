{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        nerdFontsVersion = "3";
        sidePanelWidth = 0.2;
        screenMode = "half";
        enlargedSideViewLocation = "top";
        showRandomTip = false;
        showBottomLine = true;
        showListFooter = true;
        showFileTree = true;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        experimentalShowBranchHeads = true;
        filterMode = "fuzzy";
        border = "rounded";
      };
      keybinding = {
        universal = {
          scrollDownMain = "J";
          scrollUpMain = "K";
          scrollDownMain-alt1 = "<c-d>";
          scrollUpMain-alt1 = "<c-u>";
        };
      };
      promptToReturnFromSubprocess = false;
      notARepository = "skip";
      git = {
        autoFetch = true;
        autoRefresh = true;
        commit = {
          signOff = true;
        };
        pagers = [
          {
            externalDiffCommand = "difft --color=always --syntax-highlight on";
          }
          {
            pager = "delta --paging=never";
            colorArg = "always";
          }
        ];
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
      };
    };
  };
}
