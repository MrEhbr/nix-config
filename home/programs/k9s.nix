{ config, lib, ... }: {
  options.my.programs.k9s.enable = lib.mkEnableOption "k9s";

  config = lib.mkIf config.my.programs.k9s.enable {
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
  };
}
