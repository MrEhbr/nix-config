{ stdenv, pkgs, fetchFromGitHub, buildNpmPackage, fetchNpmDeps, ... }:
let
  version = "4.56.3";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    rev = "${version}";
    hash = "sha256-AHNtFTmNP0qlxIJ3M91deLkYMyZhRaXhShUzCt4AbG4=";
  };

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${src}/ui";
    hash = "sha256-FazRZhHAopAcYZNcrchw0rx0sJ149Bje5+9bDf6Q7Aw=";
  };
in

buildNpmPackage {
  pname = "homebridge-config-ui-x";
  inherit version src;

  nodejs = pkgs.nodejs_24;

  # Deps hash for the root package
  npmDepsHash = "sha256-Nrp5gZPMwHTm2FALYNpdz2q5fHFyvR3sSQ8hmesh+LQ=";

  # Need to also run npm ci in the ui subdirectory
  preBuild = ''
    # Tricky way to run npmConfigHook multiple times
    (
      source ${pkgs.npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=ui npmDeps=${npmDeps_ui} npmConfigHook
    )
    # Required to prevent "ng build" from failing due to
    # prompting user for autocompletion
    export CI=true
  '';

  nativeBuildInputs = with pkgs; [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];
}
