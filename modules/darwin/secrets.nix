{
  config,
  lib,
  inputs,
  user,
  ...
}:
let
  cfg = config.my.secrets;

  sshKey = file: path: {
    symlink = false;
    inherit path;
    file = "${inputs.secrets}/${file}";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };
in
{
  options.my.secrets = {
    github.enable = lib.mkEnableOption "GitHub ssh key at ~/.ssh/id_github";
    work.enable = lib.mkEnableOption "work ssh keys at ~/.ssh/id_work and ~/.ssh/id_work_gitlab";
  };

  config.age = {
    identityPaths = [
      "/Users/${user}/.ssh/id_ed25519"
    ];

    secrets = lib.mkMerge [
      (lib.mkIf cfg.github.enable {
        "github-ssh-key" = sshKey "github-ssh-key.age" "/Users/${user}/.ssh/id_github";
      })
      (lib.mkIf cfg.work.enable {
        "work-ssh-key" = sshKey "work-ssh-key.age" "/Users/${user}/.ssh/id_work";
        "work-gitlab-ssh-key" = sshKey "work-ssh-key-gitlab.age" "/Users/${user}/.ssh/id_work_gitlab";
      })
    ];
  };
}
