#
# router-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # IP forwarding config
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # By default, don't automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.wan.accept_ra" = 2;
    "net.ipv6.conf.wan.autoconf" = 1;
  };

  # Networking interfaces
  networking.bridges = {
    lan = {
      interfaces = [
        "enp1s0f0"
        "enp1s0f1"
        "enp1s0f2"
        "enp1s0f3"
        "wlp3s0"
      ];
    };
  };
  networking.interfaces = {
    eno1 = {
      useDHCP = true;
    };

    lan = {
      ipv4.addresses = [{
        address = "192.168.10.1";
        prefixLength = 24;
      }];
    };

    iot = {
      ipv4.addresses = [{
        address = "192.168.50.1";
        prefixLength = 24;
      }];
    };
  };

  # NAT config
  networking.nat = {
    enable = true;
    internalInterfaces = [ "lan" ];
    externalInterface = "eno1";
  };

  # DNS/DHCP config
  services.dnsmasq = {
    enable = true;
    settings = {
      # sensible behaviours
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      # upstream DNS servers
      server = [
        "1.1.1.1"
        "9.9.9.9"
        "1.0.0.1"
      ];

      # local domains
      expand-hosts = true;
      domain = "home";
      local = "/home/";

      # Interfaces to use DNS on
      interface = [
        "lan"
        "iot"
      ];

      # subnet IP blocks to use DHCP on
      dhcp-range = [
        "192.168.10.101,192.168.10.254,24h"
        "192.168.50.101,192.168.50.254,24h"
      ];

      # static IPs
      dhcp-host = [
        "F0:B3:EC:02:98:26,192.168.10.2"  # AppleTV
        "88:E8:7F:E7:64:FC,192.168.10.3"  # SWS
        "16:94:B4:87:DC:9B,192.168.10.4"  # iAdwin
        "8C:85:90:00:F6:E1,192.168.10.5"  # rMB-MAC
        "64:B5:C6:19:6F:EE,192.168.10.6"  # NintendoSwitch
        "24:FD:52:E3:48:0F,192.168.10.7"  # LENOVO-PC
        "28:B2:BD:9B:16:94,192.168.10.8"  # THINKPAD-PC
        "B0:BE:83:78:05:04,192.168.10.9"  # creema
        "28:D2:44:14:39:2C,192.168.10.10" # nas
        "28:CF:E9:86:37:AA,192.168.10.11" # Speaker-Room
        "54:E4:3A:E8:B5:B8,192.168.10.12" # Speaker-Bathroom
        "E0:2B:96:9E:FC:0C,192.168.10.13" # HomePod
        "AA:D1:75:8B:DA:1E,192.168.10.14" # iPad
        "A4:B1:C1:92:9A:C3,192.168.10.15" # therig
        "DC:A6:32:8F:0F:1A,192.168.10.21" # raspi
        "DC:A6:32:8F:0F:1B,192.168.10.22" # raspi4
        "00:1F:A7:82:79:9B,192.168.10.17" # PS3
        "7E:D8:1C:6C:9D:A5,192.168.10.18" # SurfaceDuo
        "28:D2:44:F7:CC:11,192.168.10.69" # THINKPAD-PC LAN

        "BC:DD:C2:B7:48:DA,192.168.50.2"  # IR-Bridge
        "CC:50:E3:5F:08:81,192.168.50.3"  # SmartPlug-Room
        "CC:50:E3:5F:14:7C,192.168.50.4"  # SmartPlug-Kitchen
        "C8:2B:96:1E:1F:8E,192.168.50.5"  # Sensor-Room
        "D8:F1:5B:C3:9B:9A,192.168.50.6"  # SmartPlug-Counter
        "CC:50:E3:E5:56:CA,192.168.50.7"  # SmartBulb-Bedroom-1
        "2C:F4:32:34:01:E2,192.168.50.8"  # SmartBulb-Bedroom-2
      ];

      rebind-domain-ok = "plex.direct";
    };
  };

  # Static hosts
  networking.hosts = {
    "192.168.1.10" = [
      "sonarr.iadw.in"
      "radarr.iadw.in"
      "lidarr.iadw.in"
      "transmission.iadw.in"
      "router.iadw.in"
      "home.iadw.in"
      "prowlarr.iadw.in"
      "grafana.iadw.in"
      "nas.iadw.in"
    ];
  };

  # Firewall config
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "lan" ];

    interfaces = {
      eno1 = {
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };

      # @TODO block outgoing connections
      iot = {
        allowedTCPPorts = [
          53 # DNS
        ];
        allowedUDPPorts = [
          53  # DNS
          67  # DHCP
          68  # DHCP
          123 # NTP
        ];
      };
    };
  };

  # Wireless config
  services.hostapd = {
    enable = true;
    countryCode = "JP";
    interface = "wlp3s0";
    extraConfig = ''
      ssid=nix
      auth_algs=1
      wpa_psk_file=/home/${username}/.secrets/wifi_psk
      wpa=2
      wpa_pairwise=CCMP
      wpa_key_mgmt=WPA-PSK

      # # iot network
      # bss=iot
      # ssid=nix_iot
      # auth_algs=1
      # ap_isolate=1
      # wpa_psk_file=/home/${username}/.secrets/wifi_iot_psk
      # wpa=2
      # wpa_pairwise=CCMP
      # wpa_key_mgmt=WPA-PSK
    '';
  };

  # Packages
  environment.systemPackages = with pkgs; [
    iw
    iperf3
  ];

  # Import addtional user profiles for this machine
  _module.args.profiles = [];
}
