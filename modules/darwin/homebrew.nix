{ config, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    global.brewfile = true;


    taps = [ ];
    brews = [ "openssl@3" "luajit" "luarocks" "code2prompt" "colima" "gonzo" "openjdk" "mcat" "mole" ];
    casks = [
      "1password"
      "1password-cli"
      # Development Tools
      "zed"
      "visual-studio-code"
      "datagrip"
      "chatgpt"
      "claude"
      "container"
      # "ghostty"
      "yaak"
      "bruno"

      # Communication Tools
      "slack"
      "telegram"
      "zoom"

      # Utility Tools
      "appcleaner"
      "bartender"
      "betterdisplay"
      "numi"
      "tempbox"
      "the-unarchiver"
      "transmission"

      # Productivity Tools
      # "raycast"
      "obsidian"
      "reader"

      # Browsers
      "firefox@developer-edition"
      # "google-chrome"

      "bambu-studio"
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
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';



}
