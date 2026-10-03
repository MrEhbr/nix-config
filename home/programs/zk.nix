{ pkgs, ... }: {
  programs.zk = {
    enable = true;
    settings = {
      notebook.dir = "~/Notes";
      tool = {
        shell = "${pkgs.fish}/bin/fish";
      };
    };
  };
}
