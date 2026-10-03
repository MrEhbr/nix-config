{
  buildGoModule,
  fetchFromGitHub,
  go-mockery,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.25.0";
  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-azs1tf9eR4MVSdjMdd3U/xdPAANn1Kyamf0TwFrBSTU=";
  };
  nativeBuildInputs = [ go-mockery ];
  preBuild = "mockery";
  proxyVendor = true;
  vendorHash = "sha256-VRRjmcjEyCFq+omxOeONCL+6HEBQySHK69r4TrkyuDQ=";
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];
  meta.mainProgram = "sesh";
}
