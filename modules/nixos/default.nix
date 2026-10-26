{
  inputs,
  user,
  constants,
  ...
}:

{
  imports = [
    ../common
    ./secrets.nix
    ./services
    inputs.agenix.nixosModules.default
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit user constants; };
    users.${user} = import ../../home/linux;
  };
}
