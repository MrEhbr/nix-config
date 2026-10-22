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
    anthropic.enable = lib.mkEnableOption "Anthropic API key at /run/agenix/anthropic-api-key";
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
      (lib.mkIf cfg.anthropic.enable {
        "anthropic-api-key" = {
          file = "${inputs.secrets}/anthropic-api-key.age";
          mode = "400";
          owner = "${user}";
          group = "staff";
        };
      })
    ];
  };
}
