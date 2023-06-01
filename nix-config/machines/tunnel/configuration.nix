#
# tunnel-specific configs
#

{ ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Configure firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 80 443 32400 ];
    allowedUDPPorts = [];
  };

  # Configure fail2ban
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = ''
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
