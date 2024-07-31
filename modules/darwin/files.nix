{ user, config, pkgs, ... }:

let
  # xdg_configHome = "${config.users.users.${user}.home}/.config";
  # xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  # xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
  workPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnf2VEhtghNB/3Ry7+uwL/0rs8WRT4LKfg6b/HeKiY2 aleksey.burmistrov@quadcode.com";
in
{
  ".ssh/id_work.pub" = {
    text = workPublicKey;
  };
}
