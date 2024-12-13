{ pkgs ? import <nixpkgs> { }, ... }: {
  adguard-exporter = pkgs.callPackage ./adguard-home-exporter { };
  dev-env = pkgs.callPackage ./dev-env { };
  macism = pkgs.callPackage ./macism { };
  homebridge = pkgs.callPackage ./homebridge { };
  homebridge-config-ui-x = pkgs.callPackage ./homebridge-ui-x { };
  speedtest-exporter = pkgs.callPackage ./speedtest-exporter { };
}
