{ agenix, nixpkgs-stable, user, constants, ... }:

{
  imports = [
    ../common
    ./secrets.nix
    ./services
    agenix.nixosModules.default
  ];

  nixpkgs.overlays = [
    # vector 0.55 in unstable fails to build due to #![deny(warnings)]
    # tripping on an unstable_name_collisions lint from newer rustc.
    (_final: prev: {
      vector = nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.vector;
    })
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit user constants; };
    users.${user} = import ../../home/linux;
  };
}
