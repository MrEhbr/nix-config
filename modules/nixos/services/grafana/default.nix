{ ... }:
let
  domain = "ehbr.cloud";
in
{
  services = {
    grafana = {
      enable = true;
      settings.server = {
        domain = "grafana.${domain}";
        http_addr = "0.0.0.0";
        http_port = 3100;
      };
      settings."auth.anonymous" = {
        enabled = true;
        org_role = "Editor";
      };

      provision = {
        enable = true;
        datasources.settings = {
          deleteDatasources = [
            { name = "VictoriaMetrics"; orgId = 1; }
          ];
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              uid = "PBFA97CFB590B2093";
              url = "http://localhost:8428";
              isDefault = true;
              editable = true;
            }
          ];
        };
        dashboards.settings.providers = [
          {
            options.path = "/etc/dashboards";
          }
        ];
      };
    };

    grafana-image-renderer = {
      enable = true;
      provisionGrafana = true;
      settings.service = {
        metrics.enabled = true;
        port = 3030;
      };
    };

  };

  # Provision each dashboard in /etc/dashboard
  environment.etc = builtins.mapAttrs
    (
      name: _: {
        target = "dashboards/${name}";
        source = ./. + "/dashboards/${name}";
      }
    )
    (builtins.readDir ./dashboards);
}
