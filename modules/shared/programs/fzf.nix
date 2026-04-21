{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [
      "--layout=reverse"
      "--info=hidden"
      "--ansi"
      "--pointer=👉"
      "--gutter= "
      "--color=current-bg:-1,current-fg:blue,gutter:-1"
      "--color=header-bg:-1,header-border:cyan"
      "--color=hl+:yellow,hl:yellow"
      "--color=input-border:yellow,list-border:blue"
      "--color=pointer:blue,preview-border:cyan"
    ];
  };
}
