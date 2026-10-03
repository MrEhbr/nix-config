{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-dash
      gh-enhance
    ];
    settings = {
      git_protocol = "ssh";
    };
  };
}
