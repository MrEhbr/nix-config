{ lib, stdenv, fetchurl, unzip, darwin, swift }:

stdenv.mkDerivation (finalAttrs: {
  pname = "macism";
  version = "1.4.6";

  src = fetchurl {
    url = "https://github.com/laishulu/macism/archive/refs/tags/v${finalAttrs.version}.zip";
    hash = "sha256-wdRfKlBOrBmFNvP43SxZxldfsgWf9FZgeheXS0R8kWQ=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    swift
    unzip
  ];

  buildInputs = with darwin.apple_sdk.frameworks; [
    Carbon
    Cocoa
    Foundation
  ];

  buildPhase = ''
    swiftc macism.swift
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp macism $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line MacOS Input Source Manager";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "macism";
  };
})
