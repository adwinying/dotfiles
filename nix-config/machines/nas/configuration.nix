#
# nas-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/docker.nix
    ../../modules/wireless.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Enable SSH port forwarding outside localhost
  services.openssh.settings.GatewayPorts = "clientspecified";

  # Configure Tailscale
  services.tailscale = {
    exitNode = true;
    advertiseRoutes = "192.168.1.0/24,192.168.5.0/24";
  };

  # Configure tinyproxy
  services.tinyproxy = {
    enable = true;
    settings = {
      Listen = "0.0.0.0";
      Port = 8888;
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
        credentialFiles = {
          CLOUDFLARE_DNS_API_TOKEN_FILE = "/home/${username}/.secrets/acme.env";
        };
      };
    };
  };
  users.users.${username} = {
    extraGroups = [ "acme" ];

    # iOS Shortcut key, restricted to starting the iPhone backup
    openssh.authorizedKeys.keys = [
      ''command="sudo -n systemctl start --no-block iphone-backup",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJkS6+hbHt+ZVkvkR98hBD6PAKHWF8YCXYj3JRNML5y Shortcuts on iAdwin''
    ];
  };

  # Configure caddy for private facing services
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

      valetudo = common // {
        hostName = "valetudo.iadw.in";
        extraConfig = "reverse_proxy 192.168.5.10:80";
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

      grafana = common // {
        hostName = "grafana.iadw.in";
        extraConfig = "reverse_proxy localhost:3001";
      };

      zigbee2mqtt = common // {
        hostName = "zigbee2mqtt.iadw.in";
        extraConfig = "reverse_proxy localhost:8081";
      };

      kindash = common // {
        hostName = "kindash.iadw.in";
        extraConfig = "reverse_proxy localhost:3002";
      };

      deskhud = common // {
        hostName = "deskhud.iadw.in";
        extraConfig = "reverse_proxy localhost:3003";
      };

      fs = common // {
        hostName = "fs.iadw.in";
        extraConfig = "reverse_proxy localhost:3067";
      };

      llm = common // {
        hostName = "llm.iadw.in";
        extraConfig = "reverse_proxy localhost:8317";
      };

      kody = common // {
        hostName = "kody.iadw.in";
        extraConfig = "reverse_proxy localhost:8083";
      };

      kody-apps = common // {
        hostName = "kapp.iadw.in";
        extraConfig = "reverse_proxy localhost:8083";
      };

      chat = common // {
        hostName = "chat.iadw.in";
        extraConfig = "reverse_proxy localhost:3004";
      };

      scrutiny = common // {
        hostName = "scrutiny.iadw.in";
        extraConfig = "reverse_proxy localhost:8082";
      };
    };
  };
  users.users.caddy.extraGroups = [ "acme" ];

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

  # SAMBA
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
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

    # usbmuxd replacement that also reaches paired iPhones over Wi-Fi
    services.netmuxd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.callPackage ../../packages/netmuxd.nix {}}/bin/netmuxd";
        Restart = "on-failure";
      };
    };

    # iPhone backup over Wi-Fi, triggered by an iOS Shortcut on charge.
    # iOS asks for the passcode on every backup, so it can't run on a timer.
    services.iphone-backup = {
      requires = [ "netmuxd.service" ];
      after = [ "netmuxd.service" ];
      unitConfig.RequiresMountsFor = "/mnt/storage/backup/iphone";
      script = ''
        set -eu

        export PATH=$PATH:${pkgs.findutils}/bin
        export PATH=$PATH:${pkgs.coreutils}/bin
        export PATH=$PATH:${pkgs.libimobiledevice}/bin
        export PATH=$PATH:${pkgs.rsync}/bin

        backup_dir=/mnt/storage/backup/iphone
        last_success=$backup_dir/.last-success
        snapshot_dir=$backup_dir/snapshots
        snapshots_to_keep=20

        # Skip if the last successful backup is under 12 hours old
        if [ -n "$(find $last_success -mmin -720 2>/dev/null)" ]; then
          echo "Last backup under 12 hours ago, skipping"
          exit 0
        fi

        idevicebackup2 --network backup $backup_dir
        touch $last_success

        # Snapshot the backup, hardlinking files unchanged since the previous snapshot
        mkdir -p $snapshot_dir
        previous=$(ls -1d $snapshot_dir/*/ 2>/dev/null | tail -n 1)
        rsync -a --exclude /snapshots --exclude /.last-success \
          ''${previous:+--link-dest=$previous} \
          $backup_dir/ $snapshot_dir/$(date +%Y-%m-%dT%H%M)/
        ls -1d $snapshot_dir/*/ | head -n -$snapshots_to_keep | xargs -r rm -rf
      '';
      serviceConfig = {
        Type = "oneshot";
        User = username;
      };
    };
  };

  # Persistent SSH connections
  services.autossh.sessions = [
    {
      # bootes:22222 → nas:22
      name = "SSH_Tunnel";
      user = username;
      extraArguments = builtins.concatStringsSep " " [
        "-N"
        "-o 'StrictHostKeyChecking no'"
        "-o 'ServerAliveInterval 60'"
        "-o 'ServerAliveCountMax 3'"
        "-p 22"
        "-i /home/${username}/.secrets/id_ed25519"
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
