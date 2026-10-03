{ options, config, lib, constants, ... }:

let
  homepagePort = 8082;
  inherit (constants) domain;
  cfg = config.my.homepage;

  groupOrder = [ "Networking" "Monitoring" "Downloaders" "Media" "Home Automation" "AI" ];
  groups = builtins.filter (g: cfg.services ? ${g}) groupOrder
    ++ builtins.filter (g: !(builtins.elem g groupOrder)) (builtins.attrNames cfg.services);
in
{
  options.my.services.homepage.enable = lib.mkEnableOption "homepage";

  options.my.homepage.services = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
    default = { };
    description = "Homepage tiles by group.";
  };

  config = lib.mkIf config.my.services.homepage.enable {
    my.secrets.names = [ "homepage" ];

    services.homepage-dashboard = {
      enable = true;
      listenPort = homepagePort;
      environmentFiles = [ config.age.secrets.homepage.path ];
      allowedHosts = "localhost:8082,127.0.0.1:8082,${domain}";
      settings = {
        title = "Homepage";
        theme = "dark";
        language = "en";
        headerStyle = "boxedWidgets";
        disableCollape = true;
        cardBlur = "md";
        color = "gray";
        fiveColumns = true;
        statusStyle = "dot";
        hideVersion = true;
        layout = [
          {
            "Networking" = {
              style = "row";
              columns = 1;
            };
          }
          {
            "Media" = {
              style = "row";
              columns = 1;
            };
          }
          {
            "Downloaders" = {
              style = "row";
              columns = 1;
            };
          }
          {
            "Monitoring" = {
              style = "row";
              columns = 1;
            };
          }
          {
            "Home Automation" = {
              style = "row";
              columns = 1;
            };
          }
          {
            "Misc" = {
              style = "row";
              columns = 1;
            };
          }
        ];
      };
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/mnt/storage";
            cputemp = true;
            uptime = true;
          };
        }
      ];
      services = map (group: { ${group} = cfg.services.${group}; }) groups;
    };

    my.homepage.services."AI" = [
      {
        Llama = {
          icon = "mdi-robot-outline";
          href = "https://llama.${domain}";
          description = "llama.cpp on sparrow";
          siteMonitor = "https://llama.${domain}/health";
        };
      }
    ];

    services.nginx.virtualHosts.${domain}.locations."/" = {
      proxyPass = "http://localhost:${toString homepagePort}";
      proxyWebsockets = true;
    };

    environment.systemPackages = [ config.services.homepage-dashboard.package ];
  };
}
