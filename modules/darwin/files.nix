{ user, config, pkgs, lib, ... }:

let
  workPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnf2VEhtghNB/3Ry7+uwL/0rs8WRT4LKfg6b/HeKiY2 aleksey.burmistrov@quadcode.com";

  ghosttyCursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "main";
    sha256 = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
  };
in
{
  ".ssh/id_work.pub" = {
    text = workPublicKey;
  };

  ".config/ghostty" = {
    source = ./config/ghostty;
    recursive = true;
  };

  ".config/ghostty/shaders" = {
    source = ghosttyCursorShaders;
    recursive = true;
  };
}
