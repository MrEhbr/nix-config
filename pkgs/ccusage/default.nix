{ stdenv
, lib
, fetchFromGitHub
, bun
, makeWrapper
, nix-update-script
,
}:

let
  version = "15.9.2";
  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "ccusage";
    tag = "v${version}";
    hash = "sha256-Hfua9lmq6xGWBOInc2Vt3sHi0GDfSoSxoN0QVehSu6o=";
  };
  ccusage-deps = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "ccusage-deps";
    nativeBuildInputs = [ bun ];
    buildPhase = ''
      runHook preBuild
      bun install --no-save --ignore-scripts
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/
      if [ -d docs ]; then
        cp -r docs $out/
      fi
      runHook postInstall
    '';
    fixupPhase = ''
      find $out -name "*.sh" -delete
    '';
    outputHash = "sha256-L9xvsIEHa5vFjEyCqNKbctw8BkePDH6KlKZTh8UiOes=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });

in
stdenv.mkDerivation {
  inherit version src;
  pname = "ccusage";
  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  buildPhase = ''
    runHook preBuild
    ln -s ${ccusage-deps}/node_modules ./node_modules
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/ccusage
    cp -r . $out/share/ccusage/
    makeWrapper ${bun}/bin/bun $out/bin/ccusage \
      --chdir "$out/share/ccusage" \
      --add-flags "run ./src/index.ts"
    runHook postInstall
  '';

  meta = {
    description = "CLI tool for analyzing Claude Code usage from local JSONL files";
    mainProgram = "ccusage";
    homepage = "https://github.com/ryoppippi/ccusage";
    license = lib.licenses.mit;
    maintainers = lib.maintainers;
  };
}
