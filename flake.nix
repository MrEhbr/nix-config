{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    secrets = {
      url = "git+ssh://git@github.com/MrEhbr/nix-secrets.git";
      flake = false;
    };
  };
  outputs = { self, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, home-manager, nixpkgs, nixpkgs-stable, disko, agenix, secrets, neovim-nightly-overlay, ... } @inputs:
    let
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system:
        let pkgs = nixpkgs.legacyPackages.${system}; in {
          default = with pkgs; mkShell {
            nativeBuildInputs = with pkgs; [
              git
              age
              nixfmt-rfc-style
              statix
              vulnix
              nixd
            ];
            shellHook = ''
              export EDITOR=vim
            '';
          };
        };

      mkApp = system: osType: scriptName: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          exec ${self}/apps/${osType}/${scriptName} "$@"
        '')}/bin/${scriptName}";
      };
      overlays = nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system:
        nixpkgs.lib.composeManyExtensions [
          (final: prev: import ./pkgs { pkgs = prev; })
          neovim-nightly-overlay.overlays.default
        ]
      );

      mkDarwinConfig = { user, system ? "aarch64-darwin" }: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // {
          pkgsStable = inputs.nixpkgs-stable.legacyPackages.${system};
          inherit user;
        };
        modules = [
          { nixpkgs.overlays = [ overlays.${system} ]; }
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              inherit user;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = true;
              autoMigrate = true;
            };
          }
          ./hosts/darwin
        ];
      };
    in
    {
      overlays = overlays;
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      devShells = forAllSystems devShell;
      apps = forAllSystems (system:
        let
          osType = if nixpkgs.lib.hasSuffix "darwin" system then "darwin" else "nixos";
        in
        {
          "build-switch" = mkApp system osType "build-switch";
          "rollback" = mkApp system osType "rollback";
          "switch" = mkApp system osType "switch";
        });
      darwinConfigurations = {
        ehbr = mkDarwinConfig { user = "ehbr"; };
        work = mkDarwinConfig { user = "aleksey.burmistrov"; };
      };

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { user = "ehbr"; }; # You can change this username as needed
        modules = [
          {
            nixpkgs.overlays = [ overlays.${system} ];
          }
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { user = "ehbr"; }; # You can change this username as needed
              users.ehbr = import ./modules/nixos/home-manager.nix; # Update this if you change the username
            };
          }
          ./hosts/nixos
        ];
      });
    };
}
