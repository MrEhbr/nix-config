{ agenix, user, constants, ... }:

{
  imports = [
    ../common
    ../../services/nixos
    ./secrets.nix
    ./services
    agenix.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit user constants; };
    users.${user} = import ../../home/linux;
  };
}
