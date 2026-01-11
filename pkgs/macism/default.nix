{ stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation {
  pname = "macism";
  version = "latest";
  srcs = [
    (fetchurl {
      url = "https://github.com/rennsax/macism/releases/download/latest/macism";
      hash = "sha256-JxmlgmJmeFEqY8iSyFpeg1/zrF+94czJ0uB1E/p3Avk=";
    })
  ];
  unpackPhase = ''
    runHook preUnpack
    for _src in $srcs; do
      cp "$_src" $(stripHash "$_src")
    done
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    chmod +x macism
    mkdir -p $out/bin
    cp macism $out/bin/
    runHook postInstall
  '';
}
