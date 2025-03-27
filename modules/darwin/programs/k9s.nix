{ ... }: {
  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        headless = false;
        logoless = true;
        noIcons = true;
        skin = "kanagawa";
      };
      skipLatestRevCheck = true;
    };

    skins = {
      kanagawa = ../config/k9s/kanagawa.yaml;
    };

    plugin.plugin = {
      modify-secret = {
        shortCut = "Ctrl-X";
        description = "Edit Decoded Secret";
        confirm = false;
        scopes = [ "secrets" ];
        command = "kubectl";
        background = false;
        args = [
          "modify-secret"
          "--context"
          "$CONTEXT"
          "--namespace"
          "$NAMESPACE"
          "$NAME"
        ];
      };
    };
  };
}
