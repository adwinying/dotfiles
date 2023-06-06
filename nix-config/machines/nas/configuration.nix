#
# nas-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/wireless.nix
    ../../modules/tailscale.nix
  ];

  # Prevent sleep when laptop lid is closed
  services.logind.lidSwitch = "ignore";

  # Enable IP forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Enable SSH port forwarding outside localhost
  services.openssh.settings.GatewayPorts = "clientspecified";

  # Configure caddy
  services.caddy = {
    enable = true;
    virtualHosts = let
      common = {
        useACMEHost = "iadw.in";
      };
    in {
      router = common // {
        hostName = "router.iadw.in";
        extraConfig = "reverse_proxy 192.168.1.1:80";
      };

      transmission = common // {
        hostName = "transmission.iadw.in";
        extraConfig = "reverse_proxy localhost:9091";
      };

      prowlarr = common // {
        hostName = "prowlarr.iadw.in";
        extraConfig = "reverse_proxy localhost:9696";
      };

      sonarr = common // {
        hostName = "sonarr.iadw.in";
        extraConfig = "reverse_proxy localhost:8989";
      };

      radarr = common // {
        hostName = "radarr.iadw.in";
        extraConfig = "reverse_proxy localhost:7878";
      };

      lidarr = common // {
        hostName = "lidarr.iadw.in";
        extraConfig = "reverse_proxy localhost:8686";
      };

      home = common // {
        hostName = "home.iadw.in";
        extraConfig = "reverse_proxy localhost:8123";
      };

      plex = common // {
        hostName = "plex.iadw.in";
        extraConfig = "reverse_proxy localhost:32400";
      };

      egs = common // {
        hostName = "egs.iadw.in";
        extraConfig = "reverse_proxy localhost:3000";
      };

      grafana = common // {
        hostName = "grafana.iadw.in";
        extraConfig = "reverse_proxy localhost:3001";
      };
    };
  };
  users.users.caddy.extraGroups = [ "acme" ];

  # Configure cloudflared
  services.cloudflared = {
    enable = true;
    user = username;
    tunnels.home = {
      credentialsFile = "/home/${username}/.secrets/cloudflare_tunnel.json";
      default = "http_status:404";
      ingress = {
        "egs.iadw.in" = "https://nas.iadw.in";
        "home.iadw.in" = "https://nas.iadw.in";
        "grafana.iadw.in" = "https://nas.iadw.in";
      };
    };
  };

  # Configure firewall
  networking.firewall = {
    allowedTCPPorts = [
      # SSH
      22
      # HTTP
      80
      # HTTPS
      443
      # Home Assistant
      8123
      # Plex
      32400
      # Homekit
      21063
      51827
    ];
    allowedUDPPorts = [
      # mDNS
      5353
    ];
  };

  # SMTP
  programs.msmtp = {
    enable = true;
    defaults = {
      auth = true;
      tls = true;
      logfile = "/var/log/msmtp.log";
    };
    accounts = {
      default = {
        host = "mail.smtp2go.com";
        port = "2525";
        from = "nas@iadw.in";
        user = "nas@iadw.in";
        passwordeval = "cat /home/${username}/.secrets/smtp_password.txt";
      };
    };
  };

  # Hard Disks
  environment.systemPackages = [ pkgs.mergerfs ];
  fileSystems = {
    "/mnt/disk1" = {
      device = "/dev/disk/by-uuid/cc04b2b2-b333-459a-9e2a-7c5b28a88604";
      fsType = "ext4";
    };

    "/mnt/disk2" = {
      device = "/dev/disk/by-uuid/25c7a69c-aef6-44b5-8533-b79e27063a92";
      fsType = "ext4";
    };

    "/mnt/storage" = {
      device = "/mnt/disk*";
      fsType = "fuse.mergerfs";
      options = [
        "defaults"
        "nonempty"
        "allow_other"
        "use_ino"
        "cache.files=off"
        "moveonenospc=true"
        "category.create=lfs"
        "dropcacheonclose=true"
        "minfreespace=5G"
        "fsname=mergerfs"
      ];
      depends = [
        "/mnt/disk1"
        "/mnt/disk2"
      ];
    };
  };

  # SMART monitoring
  services.smartd = {
    enable = true;
    autodetect = true;
    defaults.monitored = builtins.concatStringsSep " " [
      "-a"
      "-o on"
      "-S on"
      "-n standby,q"
      "-s (S/../.././02|L/../../6/03)"
      "-W 4,35,50"
    ];
    notifications.mail = {
      enable = true;
      sender = "nas@iadw.in";
      recipient = "admin@iadw.in";
    };
  };

  # SAMBA
  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      NAS = {
        comment = "NAS";
        path = "/mnt/storage";
        writable = "yes";
        "guest ok" = "yes";
        "create mask" = "0775";
        "directory mask" = "0775";
        "force user" = username;
        "write cache size" = "524288";
        "getwd cache" = "yes";
        "use sendfile" = "yes";
        "min receivefile size" = "16384";
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY";
      };
    };
  };

  # Let's Encrypt
  security.acme = {
    acceptTerms = true;
    certs = {
      "iadw.in" = {
        domain = "*.iadw.in";
        email = "admin@iadw.in";
        group = "acme";
        dnsProvider = "cloudflare";
        credentialsFile = "/home/${username}/.secrets/acme.env";
      };
    };
  };
  users.users.${username}.extraGroups = [ "acme" ];

  # Server Healthcheck (curl endpoint every 3 mins)
  systemd = {
    timers.healthcheck = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "3m";
        OnUnitActiveSec = "3m";
        Unit = "healthcheck.service";
      };
    };

    services.healthcheck = {
      script = ''
        set -eu

        export PATH=$PATH:${pkgs.coreutils}/bin
        export PATH=$PATH:${pkgs.curl}/bin

        healthcheck_endpoint_path=/home/${username}/.secrets/healthcheck_server_endpoint
        healthcheck_endpoint_url=$(cat $healthcheck_endpoint_path)

        curl -fsS --retry 3 $healthcheck_endpoint_url
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };

  # Persistent SSH connections
  services.autossh.sessions = let
    commonOptions = builtins.concatStringsSep " " [
      "-N"
      "-o 'StrictHostKeyChecking no'"
      "-o 'ServerAliveInterval 60'"
      "-o 'ServerAliveCountMax 3'"
      "-p 22"
      "-i /home/${username}/.secrets/id_ed25519"
    ];
  in [
    {
      # tunnel:32400 → nas:32400
      name = "SSH_Portforwarding";
      user = "root";
      extraArguments = builtins.concatStringsSep " " [
        commonOptions
        "-R 0.0.0.0:32400:localhost:32400"
        "adwin@tunnel"
      ];
    }

    {
      # bootes:22222 → nas:22
      name = "SSH_Tunnel";
      user = "root";
      extraArguments = builtins.concatStringsSep " " [
        commonOptions
        "-R 22222:localhost:22"
        "adwin@bootes"
      ];
    }
  ];

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/backup.nix
    ../../profiles/docker_update.nix
  ];
}
