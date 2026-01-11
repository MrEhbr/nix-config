{ pkgs, ... }:
pkgs.buildNpmPackage rec {
  pname = "homebridge";
  version = "1.8.3";
  src = pkgs.fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    rev = "v${version}";
    hash = "sha256-fkIIZ0JbF/wdBWUIxoCP2Csv0w0I/3Xi/A+s79vcNWU=";
  };

  nodejs = pkgs.nodejs_24;

  npmDepsHash = "sha256-11f+RDrGtdbXX0U7oJT3Pp6w4ILCG36BPDXzmjkpppU=";
}
