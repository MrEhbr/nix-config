{ user, constants, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit user constants; };
    users.${user} = import ../../home/darwin;
    sharedModules = [
      { targets.darwin.linkApps.enable = false; }
    ];
  };
}
