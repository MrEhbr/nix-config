{ config, pkgs, pkgsStable, lib, home-manager, user, ... }:

let
  sharedFiles = import ../shared/files.nix { inherit user config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs lib; };
in
{
  imports = [
    ./dock
    ./services
    ./homebrew.nix
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.${user} = { pkgs, config, lib, ... }: {
      _module.args.user = user;
      
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { pkgsStable = pkgsStable; };
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        sessionVariables = {
          LC_ALL = "en_US.UTF-8";
          EDITOR = "nvim";
          GOPATH = "$HOME/Go";
          GOBIN = "$HOME/Go/bin";
          BUN_INSTALL = "$HOME/.bun";
          DIRENV_WARN_TIMEOUT = "5m";
          DIRENV_LOG_FORMAT = "";
          RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
          RAINFROG_CONFIG = "$HOME/.config/rainfrog";
        };

        stateVersion = "25.05";
      };

      imports = [
        ../shared/home-manager.nix
        ./programs

      ];

      programs = {
        tmux.enable = true;
      };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };


  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      username = user;
      entries = [
        { path = "/System/Applications/Mail.app/"; }
        { path = "/System/Applications/Calendar.app/"; }
        { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/"; }
        { path = "/System/Applications/Music.app/"; }
        { path = "/Applications/Obsidian.app/"; }
        { path = "/Applications/Ghostty.app/"; }
        { path = "/Applications/Telegram.app/"; }
        { path = "/Applications/Slack.app/"; }
        { path = "/System/Applications/System Settings.app/"; }
      ];
    };
  };
}
