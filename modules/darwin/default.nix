{
  inputs,
  pkgs,
  user,
  ...
}:
{

  imports = [
    ./secrets.nix
    ./users.nix
    ./home-manager.nix
    ./applications.nix
    ./system-defaults.nix
    ./dock
    ./homebrew.nix
    ../common
    inputs.agenix.darwinModules.default
  ];

  # Enable sudo authentication with Touch ID
  environment.etc."pam.d/sudo_local" = {
    text = ''
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth       sufficient     pam_tid.so
    '';
  };

  # Setup user, packages, programs
  nix = {
    enable = true;
    settings = {
      download-buffer-size = 524288000;
      trusted-users = [
        "@admin"
        "${user}"
      ];
      warn-dirty = false;
      auto-optimise-store = false;

    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  environment.shells = [
    pkgs.fish
  ];

  environment.systemPackages = [ pkgs.pam-reattach ];

  system = {
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;
  };
}
