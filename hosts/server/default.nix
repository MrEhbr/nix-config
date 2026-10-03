{
  pkgs,
  user,
  constants,
  ...
}:

let
  keys = [ constants.sshKeys.personal ];
in
{
  imports = [
    ./disk-config.nix
    ./hardware.nix
    ./networking.nix
    ./tuning.nix
  ];

  home-manager.users.${user}.imports = [ ./home.nix ];

  my = {
    secrets.github.enable = true;

    services = {
      adguard.enable = true;
      atuin.enable = true;
      fail2ban.enable = true;
      gatus.enable = true;
      grafana.enable = true;
      homepage.enable = true;
      llama.enable = true;
      logs.enable = true;
      media.enable = true;
      metrics.enable = true;
      nginx.enable = true;
      ntfy.enable = true;
      restic.enable = true;
      tailscale.enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Nicosia";

  nix.settings.allowed-users = [ user ];

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;
  };

  services = {
    # Let's be able to SSH into this machine
    openssh.enable = true;
  };

  # Add docker daemon
  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = "json-file";

  users.groups.storage = {
    gid = 3000;
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
        "storage"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
      shell = pkgs.fish;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    gitFull
    inetutils
  ];

  system.stateVersion = "25.05"; # Don't change this
}
