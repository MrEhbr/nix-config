{ user, ... }:

{
  home-manager.users.${user}.imports = [ ./home.nix ];

  my = {
    aerospace.enable = true;

    secrets = {
      github.enable = true;
      work.enable = true;
    };

    homebrew = {
      enable = true;
      casks = {
        onepassword.enable = true;
        dev.enable = true;
        communication.enable = true;
        utilities.enable = true;
        productivity.enable = true;
        browsers.enable = true;
      };
    };
  };

  local.dock = {
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
}
