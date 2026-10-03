{ domain }:
{
  url = subdomain: "https://${subdomain}.${domain}";

  # Gatus endpoint polled every 60s.
  endpoint =
    {
      name,
      group,
      url,
      conditions ? [ "[STATUS] == 200" ],
    }:
    {
      inherit
        name
        group
        url
        conditions
        ;
      interval = "60s";
    };

  # Prometheus scrape job for a single local target.
  scrape = job_name: port: {
    inherit job_name;
    static_configs = [ { targets = [ "127.0.0.1:${toString port}" ]; } ];
  };
}
