_:

{
  boot.kernel.sysctl = {
    "net.ipv4.tcp_timestamps" = 1; # Enable TCP timestamps
    "net.ipv4.tcp_sack" = 1; # Enable TCP Selective Acknowledgment (SACK)
    "net.ipv4.ip_forward" = 1; # Enable IP forwarding
    "net.core.netdev_max_backlog" = 2500; # Increase the maximum number of packets in the queue
    "net.core.rmem_max" = 16777216; # Increase the maximum receive socket buffer size
    "net.core.wmem_max" = 16777216; # Increase the maximum send socket buffer size
    "net.core.somaxconn" = 1024; # Increase the maximum number of incoming connections
    "net.ipv4.tcp_max_syn_backlog" = 2048; # Increase the maximum number of SYN backlog
    "net.ipv4.tcp_rmem" = "4096 87380 16777216"; # Set TCP receive buffer sizes
    "net.ipv4.tcp_wmem" = "4096 65536 16777216"; # Set TCP send buffer sizes
    "net.core.optmem_max" = 2048000; # Increase the maximum ancillary buffer size
    "vm.swappiness" = 10; # Adjust based on your system's RAM and workload
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 1048576;
    DefaultLimitNOFILESoft = 1048576;
    DefaultLimitNPROC = 1048576;
    DefaultLimitNPROCSoft = 1048576;
    DefaultLimitFSIZE = "infinity";
    DefaultLimitFSIZESoft = "infinity";
  };
}
