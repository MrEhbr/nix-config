{ lib, config, ... }:
let
  workspaces = [
    {
      name = "Main";
      key = "0";
      monitor = "secondary";
    }
    {
      name = "Web";
      key = "1";
      monitor = "secondary";
    }
    {
      name = "Term";
      key = "e";
      monitor = "secondary";
    }
    {
      name = "Chat";
      key = "3";
      monitor = "main";
    }
    {
      name = "Notes";
      key = "2";
      monitor = "main";
    }
    {
      name = "Dev";
      key = "d";
      monitor = "main";
    }
    {
      name = "Music";
      key = "m";
      monitor = "main";
    }
    {
      name = "Game";
      key = "g";
      monitor = "secondary";
    }
    {
      name = "Other";
      key = "4";
      monitor = "secondary";
    }
    {
      name = "AI";
      key = "5";
      monitor = "main";
    }
  ];

  appWorkspace = {
    "com.apple.Safari" = "Web";
    "org.mozilla.firefox" = "Web";
    "com.google.Chrome" = "Web";
    "ru.keepcoder.Telegram" = "Chat";
    "com.apple.mail" = "Chat";
    "com.tinyspeck.slackmacgap" = "Chat";
    "com.microsoft.VSCode" = "Dev";
    "dev.zed.Zed" = "Dev";
    "com.usebruno.app" = "Dev";
    "com.todesktop.230313mzl4w4u92" = "Dev";
    "com.postmanlabs.mac" = "Dev";
    "com.jetbrains.datagrip" = "Dev";
    "com.outerbase.studio" = "Dev";
    "com.mobbtech.Wheels" = "Dev";
    "com.mitchellh.ghostty" = "Term";
    "com.apple.Music" = "Music";
    "com.apple.podcasts" = "Music";
    "md.obsidian" = "Notes";
    "com.chocoford.excalidraw" = "Notes";
    "com.playstation.RemotePlay" = "Game";
    "com.anthropic.claudefordesktop" = "AI";
    "com.openai.chat" = "AI";
    "com.openai.codex" = "AI";
  };

  floatingApps = [
    "com.apple.finder"
    "com.apple.AppStore"
    "com.1password.1password"
    "com.apple.ActivityMonitor"
    "com.docker.docker"
    "com.apple.systempreferences"
  ];

  rule = cond: run: {
    "if" = cond;
    inherit run;
  };
  float = [ "layout floating" ];
  moveTo = ws: [ "move-node-to-workspace ${ws}" ];

  workspaceBindings = lib.listToAttrs (
    map (ws: lib.nameValuePair "alt-${ws.key}" "workspace ${ws.name}") workspaces
  );
  moveBindings = lib.listToAttrs (
    map (
      ws: lib.nameValuePair "alt-shift-${ws.key}" (moveTo ws.name ++ [ "workspace ${ws.name}" ])
    ) workspaces
  );
in
{
  options.my.programs.aerospace.enable = lib.mkEnableOption "aerospace";

  config = lib.mkIf config.my.programs.aerospace.enable {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;
      settings = {
        config-version = 2;
        default-root-container-layout = "accordion";
        default-root-container-orientation = "auto";
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        accordion-padding = 30;

        persistent-workspaces = map (ws: ws.name) workspaces;
        workspace-to-monitor-force-assignment = lib.listToAttrs (
          map (ws: lib.nameValuePair ws.name ws.monitor) workspaces
        );

        gaps = {
          inner = {
            horizontal = 10;
            vertical = 10;
          };
          outer = {
            bottom = 5;
            left = 5;
            right = 5;
            top = 5;
          };
        };

        key-mapping.preset = "qwerty";

        mode.main.binding =
          workspaceBindings
          // moveBindings
          // {
            alt-tab = "focus --boundaries-action wrap-around-the-workspace left";

            alt-shift-h = "move left";
            alt-shift-l = "move right";
            cmd-ctrl-h = "focus --boundaries-action wrap-around-the-workspace left";
            cmd-ctrl-l = "focus --boundaries-action wrap-around-the-workspace right";

            cmd-shift-left = "exec-and-forget aerospace list-workspaces --monitor focused --empty no | aerospace workspace next";
            cmd-shift-right = "exec-and-forget aerospace list-workspaces --monitor focused --empty no | aerospace workspace prev";

            alt-shift-space = "layout floating tiling";
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
            # Resize
            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            alt-f = "fullscreen";
          };

        # First matching rule wins: specific rules, then per-app rules, then the catch-all.
        on-window-detected = [
          (rule { app-name-regex-substring = "Google Meet"; } (moveTo "Chat"))
          (rule {
            app-id = "com.mitchellh.ghostty";
            window-title-regex-substring = "Software Update";
          } float)
          (rule {
            app-id = "com.mitchellh.ghostty";
            window-title-regex-substring = "Updating Ghostty";
          } float)
          (rule { app-id = "com.cisco.secureclient.gui"; } (float ++ moveTo "Other"))
        ]
        ++ map (app: rule { app-id = app; } float) floatingApps
        ++ lib.mapAttrsToList (app: ws: rule { app-id = app; } (moveTo ws)) appWorkspace
        ++ [ (rule { } float) ];
      };
    };
  };
}
