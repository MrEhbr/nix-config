{ agenix, user, ... }:

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
    extraSpecialArgs = { inherit user; };
    users.${user} = import ../../home/linux;
  };
}
