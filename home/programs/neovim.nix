{ config, lib, ... }:

{
  options.my.programs.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.my.programs.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      sideloadInitLua = true;
    };
  };
}
