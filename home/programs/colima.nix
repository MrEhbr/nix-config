{ pkgs, ... }:
{
  services.colima = {
    enable = true;

    profiles.default = {
      isService = true;
      isActive = true;
      setDockerHost = true;

      settings = {
        cpu = 4;
        memory = 8;
        disk = 100;
        arch = "aarch64";
        runtime = "docker";
        vmType = "vz";
        mountType = "virtiofs";
        mountInotify = true;
        autoActivate = true;
        forwardAgent = false;
        rosetta = false;
        binfmt = true;
        nestedVirtualization = false;
        portForwarder = "ssh";
        sshConfig = true;
      };
    };
  };
}
