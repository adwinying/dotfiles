#
# tunnel-specific configs
#

{ lib, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Let's Encrypt
  security.acme = {
    acceptTerms = true;
    certs = {
      "iadw.in" = {
        domain = "*.iadw.in";
        email = "admin@iadw.in";
        group = "acme";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        credentialsFile = "/home/${username}/.secrets/acme.env";
      };
    };
  };
  users.users.${username}.extraGroups = [ "acme" ];

  # Configure caddy
  services.caddy = {
    enable = true;
    virtualHosts = let
      common = {
        useACMEHost = "iadw.in";
      };
    in {
      plex = common // {
        hostName = "plex.iadw.in";
        extraConfig = "reverse_proxy localhost:32400";
      };
    };
  };
  users.users.caddy.extraGroups = [ "acme" ];

  # Configure firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 80 443 32400 ];
    allowedUDPPorts = [];
  };

  # Configure fail2ban
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = lib.mkForce ''
        enabled  = true
        port     = 22
        filter   = sshd
        logpath  = /var/log/auth.log
        findtime = 3600
        bantime  = 300
        maxretry = 2
      '';

      sshd-persistent = ''
        enabled  = true
        port     = ssh
        logpath  = /var/log/auth.log
        filter   = sshd
        bantime  = 604800
        findtime = 604800
        maxretry = 19
      '';
    };
  };

  # Enable SSH port forwarding outside localhost
  services.openssh.settings.GatewayPorts = "clientspecified";

  # Import addtional user profiles for this machine
  _module.args.profiles = [];
}
