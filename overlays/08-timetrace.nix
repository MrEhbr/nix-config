self: super: with super; {
  timetrace =
    let
      pname = "timetrace";
      version = "0.14.3";
    in
    pkgs.buildGoModule {
      name = pname;
      pname = pname;

      src = fetchFromGitHub {
        owner = "dominikbraun";
        repo = "timetrace";
        rev = "v${version}";
        sha256 = "sha256-qrAel/ls2EKJSnKXjVC9RNsFaaqGr0R8ScHvqEiOHEI=";
      };
      vendorHash = "sha256-bcOH/CLCQBIG5d9XUtgIswJd+g5F2imaY6LdqKdvfHo=";

      outputs = [ "out" ];
    };
}
