{ user, pkgs, config, ... }:

let
  personalPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxk1quGRSKZkYR6tLHTFTLUJ+nyu+037Vzbjj7ZCZIq mr.ehbr@gmail.com";
in
{
  ".ssh/id_github.pub" = {
    text = personalPublicKey;
  };
  ".config/tlrc/config.toml".text = ''
    [cache]
    auto_update = true
    max_age = 336 # 336 hours = 2 weeks
  '';
}
