{ pkgs, lib, ... }:
let
  sesh-latest = pkgs.buildGoModule rec {
    pname = "sesh";
    version = "2.24.2";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "sesh";
      rev = "v${version}";
      hash = "sha256-iisAIn4km/uFw2DohA2mjoYmKgDQ3lYUH284Le3xQD0=";
    };
    nativeBuildInputs = [ pkgs.go-mockery ];
    preBuild = "mockery";
    proxyVendor = true;
    vendorHash = "sha256-Jm0JNrJpnKns2pokbBwHps4Q3EYPyzAVCKbyNj6tcnA=";
    ldflags = [ "-s" "-w" "-X main.version=${version}" ];
    meta.mainProgram = "sesh";
  };
in
{
  programs.sesh = {
    enable = true;
    package = sesh-latest;
    enableTmuxIntegration = false;
    enableAlias = false;
    settings = {
      sort_order = [ "tmux" "config" "zoxide" ];
      dir_length = 2;
      blacklist = [ "floating_pane_*" ];
      import = [ "~/.config/sesh/local.toml" ];
    };
  };
}
