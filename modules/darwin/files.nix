{ user, config, pkgs, lib, ... }:

let
  workPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnf2VEhtghNB/3Ry7+uwL/0rs8WRT4LKfg6b/HeKiY2 aleksey.burmistrov@quadcode.com";
in
{
  ".ssh/id_work.pub" = {
    text = workPublicKey;
  };

  ".config/ghostty/config" = {
    text = builtins.readFile ./config/ghostty/config;
  };
}
