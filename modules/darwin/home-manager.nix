{ config, pkgs, pkgsStable, lib, user, constants, ... }:

{
  imports = [
    ./dock
    ./aerospace.nix
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
    extraSpecialArgs = { inherit user pkgsStable constants; };
    users.${user} = import ../../home/darwin;
    sharedModules = [
      { targets.darwin.linkApps.enable = false; }
    ];
  };

  system.build.applications = lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = [ "/Applications" ];
      paths =
        config.environment.systemPackages
        ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );
}
