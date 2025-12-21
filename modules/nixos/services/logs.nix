{ ... }:
{
  services.victorialogs = {
    enable = true;
  };

  services.journald.upload = {
    enable = true;
    settings.Upload = {
      URL = "http://localhost:9428/insert/journald";
    };
  };
}
