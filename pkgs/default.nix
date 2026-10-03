{ pkgs ? import <nixpkgs> { }, ... }: {
  dev-env = pkgs.callPackage ./dev-env { };
}
