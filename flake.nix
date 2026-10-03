{
  description = "Darwin and NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      devShell =
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              git
              age
              nixfmt
              statix
              deadnix
              vulnix
              nixd
              just
            ];
            shellHook = ''
              export EDITOR=vim
            '';
          };
        };

      lint =
        system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.runCommand "lint"
          {
            nativeBuildInputs = with pkgs; [
              deadnix
              statix
              nixfmt
              findutils
            ];
          }
          ''
            cd ${self}
            deadnix --fail .
            statix check .
            find . -name '*.nix' -exec nixfmt --check {} +
            touch $out
          '';

      hostChecks =
        system:
        let
          darwinHosts = nixpkgs.lib.filterAttrs (
            _: c: c.pkgs.stdenv.hostPlatform.system == system
          ) self.darwinConfigurations;
          nixosHosts = nixpkgs.lib.filterAttrs (
            _: c: c.pkgs.stdenv.hostPlatform.system == system
          ) self.nixosConfigurations;
        in
        nixpkgs.lib.mapAttrs (_: c: c.system) darwinHosts
        // nixpkgs.lib.mapAttrs (_: c: c.config.system.build.toplevel) nixosHosts;
    in
    {
      overlays.default = lib.overlay;
      packages = lib.forAllSystems (system: import ./pkgs { pkgs = pkgsFor system; });
      devShells = lib.forAllSystems devShell;
      formatter = lib.forAllSystems (system: (pkgsFor system).nixfmt-tree);
      checks = lib.forAllSystems (system: { lint = lint system; } // hostChecks system);

      darwinConfigurations = {
        ehbr = lib.mkDarwin {
          host = "ehbr";
          user = "ehbr";
        };
        work = lib.mkDarwin {
          host = "work";
          user = "aleksey.burmistrov";
        };
      };

      nixosConfigurations = {
        server = lib.mkNixos {
          host = "server";
          user = "ehbr";
        };
      };
    };
}
