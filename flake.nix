{
  description = "Darwin and NixOS configuration";
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
  outputs = { nixpkgs, ... } @inputs:
    let
      lib = import ./lib { inherit inputs; };

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
    in
    {
      inherit (lib) overlays;
      packages = lib.forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
      devShells = lib.forAllSystems devShell;

      darwinConfigurations = {
        ehbr = lib.mkDarwin { host = "ehbr"; user = "ehbr"; };
        work = lib.mkDarwin { host = "work"; user = "aleksey.burmistrov"; };
      };

      nixosConfigurations = {
        server = lib.mkNixos { host = "server"; user = "ehbr"; };
      };
    };
}
