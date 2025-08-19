{ config, pkgs, agenix, secrets, user, ... }:
{
  age = {
    identityPaths = [
      "/Users/${user}/.ssh/id_ed25519"
    ];

    secrets = {
      "github-ssh-key" = {
        symlink = false;
        path = "/Users/${user}/.ssh/id_github";
        file = "${secrets}/github-ssh-key.age";
        mode = "600";
        owner = "${user}";
        group = "staff";
      };
      "work-ssh-key" = {
        symlink = false;
        path = "/Users/${user}/.ssh/id_work";
        file = "${secrets}/work-ssh-key.age";
        mode = "600";
        owner = "${user}";
        group = "staff";
      };
      "aichat_openai" = {
        symlink = false;
        path = "/Users/${user}/.config/openai/aichat_openai";
        file = "${secrets}/aichat_openai.age";
        mode = "600";
        owner = "${user}";
        group = "staff";
      };
    };
  };
}
