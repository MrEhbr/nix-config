{ user, pkgs, config, ... }:

let
  personalPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxk1quGRSKZkYR6tLHTFTLUJ+nyu+037Vzbjj7ZCZIq mr.ehbr@gmail.com";
in
{
  ".ssh/id_github.pub" = {
    text = personalPublicKey;
  };

  # my nvim config
  # ".config/nvim".source = pkgs.fetchFromGitHub {
  #   owner = "MrEhbr";
  #   repo = "nvim-config";
  #   rev = "main";
  #   sha256 = "V84QQsexxX99RS2Lhu1qH02z7bbWK/0jH56O8LLpBDs=";
  # };
}
