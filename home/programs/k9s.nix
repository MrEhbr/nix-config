{ ... }: {
  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        headless = false;
        logoless = true;
        noIcons = true;
        skin = "transparent";
      };
      skipLatestRevCheck = true;
    };

    skins = {
      transparent = ../config/k9s/transparent.yaml;
    };

    plugins = {
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
