{ pkgs ? import <nixpkgs> { }, ... }: {
  adguard-exporter = pkgs.callPackage ./adguard-home-exporter { };
  dev-env = pkgs.callPackage ./dev-env { };
  macism = pkgs.callPackage ./macism { };
  speedtest-exporter = pkgs.callPackage ./speedtest-exporter { };
  sqlit-tui = pkgs.callPackage ./sqlit-tui { };
}
