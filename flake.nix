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
      inputs.brew-src = {
        url = "github:Homebrew/brew/7.0.4";
        flake = false;
      };
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
    homebrew-umputun-apps = {
      url = "github:umputun/homebrew-apps";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur-packages = {
      url = "github:MrEhbr/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/MrEhbr/nix-secrets.git";
      flake = false;
    };
  };
  outputs = { self, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, homebrew-umputun-apps, home-manager, nixpkgs, nixpkgs-stable, disko, agenix, secrets, neovim-nightly-overlay, nur-packages, ... } @inputs:
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

      overlays = nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system:
        nixpkgs.lib.composeManyExtensions (
          [
            (final: prev: builtins.removeAttrs (import nur-packages { pkgs = prev; }) [ "nixosModules" ])
            (final: prev: import ./pkgs { pkgs = prev; })
          ]
          ++ nixpkgs.lib.optional (nixpkgs.lib.hasSuffix "darwin" system)
            neovim-nightly-overlay.overlays.default
        )
      );

      constants = import ./lib/constants.nix;

      mkDarwin = { host, user, system ? "aarch64-darwin" }: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // { inherit user constants; };
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
                # "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "umputun/homebrew-apps" = homebrew-umputun-apps;
              };
              mutableTaps = true;
              autoMigrate = true;
            };
          }
          ./modules/darwin
          ./hosts/${host}
        ];
      };

      mkNixos = { host, user, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { inherit user constants; };
        modules = [
          {
            nixpkgs.overlays = [
              overlays.${system}
              # vector 0.55 in unstable fails to build due to #![deny(warnings)]
              # tripping on an unstable_name_collisions lint from newer rustc.
              (_final: _prev: {
                vector = inputs.nixpkgs-stable.legacyPackages.${system}.vector;
              })
            ];
          }
          disko.nixosModules.disko
          { imports = builtins.attrValues nur-packages.nixosModules; }
          home-manager.nixosModules.home-manager
          ./modules/nixos
          ./hosts/${host}
        ];
      };
    in
    {
      overlays = overlays;
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      devShells = forAllSystems devShell;
      darwinConfigurations = {
        ehbr = mkDarwin { host = "ehbr"; user = "ehbr"; };
        work = mkDarwin { host = "work"; user = "aleksey.burmistrov"; };
      };

      nixosConfigurations = {
        server = mkNixos { host = "server"; user = "ehbr"; };
      };
    };
}
