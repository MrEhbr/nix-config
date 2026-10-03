{ inputs }:
let
  inherit (inputs) nixpkgs darwin home-manager nix-homebrew disko nur-packages neovim-nightly-overlay;
  inherit (nixpkgs) lib;

  constants = import ./constants.nix;

  linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
  darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
  systems = linuxSystems ++ darwinSystems;

  overlays = lib.genAttrs systems (system:
    lib.composeManyExtensions (
      [
        (final: prev: builtins.removeAttrs (import nur-packages { pkgs = prev; }) [ "nixosModules" ])
        (final: prev: import ../pkgs { pkgs = prev; })
      ]
      ++ lib.optional (lib.hasSuffix "darwin" system)
        neovim-nightly-overlay.overlays.default
    )
  );
in
{
  inherit overlays;

  forAllSystems = lib.genAttrs systems;

  mkDarwin = { host, user, system ? "aarch64-darwin" }: darwin.lib.darwinSystem {
    inherit system;
    specialArgs = inputs // { inherit user constants; };
    modules = [
      { nixpkgs.overlays = [ overlays.${system} ]; }
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ../modules/darwin
      ../hosts/${host}
    ];
  };

  mkNixos = { host, user, system ? "x86_64-linux" }: lib.nixosSystem {
    inherit system;
    specialArgs = inputs // { inherit user constants; };
    modules = [
      { nixpkgs.overlays = [ overlays.${system} ]; }
      disko.nixosModules.disko
      { imports = builtins.attrValues nur-packages.nixosModules; }
      home-manager.nixosModules.home-manager
      ../modules/nixos
      ../hosts/${host}
    ];
  };
}
