{
  config,
  lib,
  inputs,
  user,
  ...
}:
let
  cfg = config.my.homebrew;
in
{
  options.my.homebrew.enable = lib.mkEnableOption "homebrew with base brews and casks";

  config = lib.mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      enableRosetta = false;
      inherit user;
      taps = {
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        "umputun/homebrew-apps" = inputs.homebrew-umputun-apps;
      };
      mutableTaps = true;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      global.brewfile = true;
      global.autoUpdate = true;

      brews = [
        "openssl@3"
        "luajit"
        "luarocks"

        "gonzo"
        "openjdk"
        "mcat"
        "mole"
        "gitlogue"
        "presenterm"
        "sqruff"
        "umputun/apps/revdiff"
      ];
      casks = [
        "1password"
        "1password-cli"
        "zed"
        "datagrip"
        "chatgpt"
        "claude"
        "container"
        "bruno"
        "slack"
        "telegram"
        "zoom"
        "appcleaner"
        "bartender"
        "betterdisplay"
        "numi"
        "tempbox"
        "the-unarchiver"
        "transmission"
        "obsidian"
        "reader"
        "firefox@developer-edition"
      ];
    };

    environment.shellInit = ''
      eval "$(${config.homebrew.prefix}/bin/brew shellenv)"
    '';
  };
}
