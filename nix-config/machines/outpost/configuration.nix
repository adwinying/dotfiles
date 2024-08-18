#
# router-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/wireless.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Enable IP forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # Configure Tailscale
  services.tailscale = {
    exitNode = true;
    acceptRoutes = true;
  };

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Configure firewall
  networking.firewall = {
    allowedTCPPorts = [
      # SSH
      22
    ];
    allowedUDPPorts = [
    ];
  };

  # Import addtional user profiles for this machine
  _module.args.profiles = [];
}
