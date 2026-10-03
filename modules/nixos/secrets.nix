{
  config,
  lib,
  inputs,
  user,
  ...
}:
let
  cfg = config.my.secrets;
in
{
  options.my.secrets = {
    github.enable = lib.mkEnableOption "GitHub ssh key at ~/.ssh/id_github";

    names = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Secrets decrypted from <secrets>/<name>.age, owned by the user and wheel, mode 600.";
    };
  };

  config = {
    age.identityPaths = [
      "/home/${user}/.ssh/id_ed25519"
    ];

    age.secrets = lib.mkMerge [
      (lib.genAttrs cfg.names (name: {
        file = "${inputs.secrets}/${name}.age";
        mode = "600";
        owner = user;
        group = "wheel";
      }))

      (lib.mkIf cfg.github.enable {
        "github-ssh-key" = {
          symlink = false;
          path = "/home/${user}/.ssh/id_github";
          file = "${inputs.secrets}/github-ssh-key.age";
          mode = "600";
          owner = "${user}";
          group = "wheel";
        };
      })
    ];
  };
}
