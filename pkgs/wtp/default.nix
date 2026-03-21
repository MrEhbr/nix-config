{ pkgs, fetchFromGitHub, lib, ... }:
let
  pname = "wtp";
  version = "2.10.3";
in
pkgs.buildGoModule {
  pname = pname;
  version = version;

  src = fetchFromGitHub {
    owner = "satococoa";
    repo = "wtp";
    rev = "v${version}";
    sha256 = "sha256-KgayKjH4iHi7LgWwk2Laba33bMVZdbiMQgSmqBSTfZ0=";
  };

  vendorHash = "sha256-zsSNo1MQgpvH3ZSd3kmvdIpOCVJgSu1/pYLltx/9dZg=";

  subPackages = [ "cmd/wtp" ];

  ldflags = [ "-X main.version=${version}" ];

  # Integration tests require a git repo, unavailable in the nix sandbox
  doCheck = false;

  meta = with lib; {
    description = "Worktree productivity tool for Git";
    homepage = "https://github.com/satococoa/wtp";
  };
}
