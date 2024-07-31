{ user, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
  xdg_dataHome = "${home}/.local/share";
  xdg_stateHome = "${home}/.local/state";
in
{

  # my nvim config
  # TODO: remove after uncommenting in shred
  xdg_configHome."nvim".source = pkgs.fetchFromGitHub {
    owner = "MrEhbr";
    repo = "nvim-config";
    rev = "main";
    sha256 = "V84QQsexxX99RS2Lhu1qH02z7bbWK/0jH56O8LLpBDs=";
  };

}
