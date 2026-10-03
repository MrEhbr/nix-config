{ config, lib, ... }:
let
  cfg = config.my.homebrew;
  inherit (cfg) casks;
  caskGroup = name: { enable = lib.mkEnableOption "${name} casks"; };
in
{
  options.my.homebrew = {
    enable = lib.mkEnableOption "homebrew with base brews";
    casks = lib.genAttrs [ "onepassword" "dev" "communication" "utilities" "productivity" "browsers" ] caskGroup;
  };

  config = lib.mkIf cfg.enable {
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
      casks = lib.mkMerge [
        (lib.mkIf casks.onepassword.enable [
          "1password"
          "1password-cli"
        ])
        (lib.mkIf casks.dev.enable [
          "zed"
          "datagrip"
          "chatgpt"
          "claude"
          "container"
          # "ghostty"
          "bruno"
        ])
        (lib.mkIf casks.communication.enable [
          "slack"
          "telegram"
          "zoom"
        ])
        (lib.mkIf casks.utilities.enable [
          "appcleaner"
          "bartender"
          "betterdisplay"
          "numi"
          "tempbox"
          "the-unarchiver"
          "transmission"
        ])
        (lib.mkIf casks.productivity.enable [
          # "raycast"
          "obsidian"
          "reader"
        ])
        (lib.mkIf casks.browsers.enable [
          "firefox@developer-edition"
          # "google-chrome"
        ])
        # "bambu-studio"
      ];

      # These app IDs are from using the mas CLI app
      # mas = mac app store
      # https://github.com/mas-cli/mas
      #
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      #
      masApps = {
        # "1Password for Safari" = 1569813296;
        # Things = 904280696;
        # Hush = 1544743900;
        # Dato = 1470584107;
        # "iStat Menus" = 6499559693;
        # "Pixelmator Pro" = 1289583905;
        # Infuse = 1136220934;
        # TailScale = 1475387142;
        # "Refined github" = 1519867270;
      };
    };

    environment.shellInit = ''
      eval "$(${config.homebrew.prefix}/bin/brew shellenv)"
    '';
  };
}
