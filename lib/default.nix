{ inputs }:
let
  inherit (inputs)
    nixpkgs
    darwin
    home-manager
    nix-homebrew
    disko
    nur-packages
    neovim-nightly-overlay
    ;
  inherit (nixpkgs) lib;

  constants = import ./constants.nix;

  linuxSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  darwinSystems = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  systems = linuxSystems ++ darwinSystems;

  overlay = lib.composeManyExtensions [
    (_final: prev: builtins.removeAttrs (import nur-packages { pkgs = prev; }) [ "nixosModules" ])
    (_final: prev: import ../pkgs { pkgs = prev; })
    (
      final: prev:
      lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin (
        neovim-nightly-overlay.overlays.default final prev
      )
    )
  ];

  specialArgs = user: { inherit inputs user constants; };
in
{
  inherit overlay;

  forAllSystems = lib.genAttrs systems;

  mkDarwin =
    {
      host,
      user,
      system ? "aarch64-darwin",
    }:
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = specialArgs user;
      modules = [
        { nixpkgs.overlays = [ overlay ]; }
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        ../modules/darwin
        ../hosts/${host}
      ];
    };

  mkNixos =
    {
      host,
      user,
      system ? "x86_64-linux",
    }:
    lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs user;
      modules = [
        { nixpkgs.overlays = [ overlay ]; }
        disko.nixosModules.disko
        { imports = builtins.attrValues nur-packages.nixosModules; }
        home-manager.nixosModules.home-manager
        ../modules/nixos
        ../hosts/${host}
      ];
    };
}
